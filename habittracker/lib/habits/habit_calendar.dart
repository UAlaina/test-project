import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCalendarScreen extends StatefulWidget {
  @override
  _HabitCalendarScreenState createState() => _HabitCalendarScreenState();
}

class _HabitCalendarScreenState extends State<HabitCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, Map<String, List<Map<String, dynamic>>>> _tasks = {};

  @override
  void initState() {
    super.initState();
    _loadTasksForMonth(_focusedDay);
  }

  void _loadTasksForMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where(FieldPath.documentId,
        isGreaterThanOrEqualTo: _formatDate(startOfMonth))
        .where(FieldPath.documentId, isLessThanOrEqualTo: _formatDate(endOfMonth))
        .get();

    setState(() {
      _tasks = {
        for (var doc in querySnapshot.docs)
          DateTime.parse(doc.id): {
            'daily': List<Map<String, dynamic>>.from(doc['daily'] ?? []),
            'weekly': List<Map<String, dynamic>>.from(doc['weekly'] ?? []),
            'monthly': List<Map<String, dynamic>>.from(doc['monthly'] ?? []),
          }
      };
    });
  }

  void _addTask(String type, DateTime date, String name) async {
    Color color;
    switch (type) {
      case 'daily':
        color = Colors.blue.shade100;
        break;
      case 'weekly':
        color = Colors.green.shade100;
        break;
      case 'monthly':
        color = Colors.orange.shade100;
        break;
      default:
        color = Colors.blue.shade100; // Default to blue if no type selected
    }

    final formattedDate = _formatDate(date);
    final task = {'name': name, 'color': color.value, 'completed': false};

    final docRef = FirebaseFirestore.instance.collection('tasks').doc(formattedDate);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({
        type: FieldValue.arrayUnion([task]),
      });
    } else {
      await docRef.set({
        'daily': [],
        'weekly': [],
        'monthly': [],
        type: [task],
      });
    }

    setState(() {
      _tasks[date] ??= {'daily': [], 'weekly': [], 'monthly': []};
      _tasks[date]![type]!.add(task);
    });
  }

  void _toggleTaskCompletion(DateTime date, String type, int index) async {
    final formattedDate = _formatDate(date);
    final task = _tasks[date]![type]![index];
    task['completed'] = !task['completed'];

    final docRef = FirebaseFirestore.instance.collection('tasks').doc(formattedDate);
    await docRef.update({
      type: _tasks[date]![type],
    });

    setState(() {
      _tasks[date]![type]![index] = task;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   //title: Text('Habit Calendar'),
      // ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadTasksForMonth(focusedDay);
            },
            eventLoader: (day) {
              final tasks = _tasks[day] ?? {};
              return [...tasks['daily'] ?? [], ...tasks['weekly'] ?? [], ...tasks['monthly'] ?? []];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final tasks = _tasks[date];
                if (tasks != null) {
                  final dailyDot = tasks['daily']?.any((task) => !task['completed']) ?? false;
                  final weeklyDot = tasks['weekly']?.any((task) => !task['completed']) ?? false;
                  final monthlyDot = tasks['monthly']?.any((task) => !task['completed']) ?? false;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (dailyDot)
                        _buildDot(Colors.blue.shade100),
                      if (weeklyDot)
                        _buildDot(Colors.green.shade100),
                      if (monthlyDot)
                        _buildDot(Colors.orange.shade100),
                    ],
                  );
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _buildTaskTable('daily', Colors.blue.shade100),
                _buildTaskTable('weekly', Colors.green.shade100),
                _buildTaskTable('monthly', Colors.orange.shade100),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _addTaskDialog,
              child: Text('Add Habit'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTaskTable(String type, Color color) {
    final tasks = _tasks[_selectedDay]?[type] ?? [];
    return Expanded(
      child: Container(
        color: color,
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return CheckboxListTile(
              title: Text(task['name']),
              value: task['completed'],
              onChanged: (_) => _toggleTaskCompletion(_selectedDay, type, index),
            );
          },
        ),
      ),
    );
  }

  void _addTaskDialog() {
    TextEditingController _taskController = TextEditingController();
    String _selectedType = 'daily';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Habit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(hintText: "Enter Habit"),
              ),
              DropdownButton<String>(
                value: _selectedType,
                items: [
                  DropdownMenuItem(value: 'daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                ],
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _addTask(_selectedType, _selectedDay, _taskController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}