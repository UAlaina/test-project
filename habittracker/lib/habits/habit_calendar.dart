import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/models/dbHelper.dart';

class HabitCalendarScreen extends StatefulWidget {
  @override
  _HabitCalendarScreenState createState() => _HabitCalendarScreenState();
}

class _HabitCalendarScreenState extends State<HabitCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, List<Task>> _tasksByType = {
    'daily': [],
    'weekly': [],
    'monthly': [],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await DbService().dbHelper.getAllTasks();

    Map<String, List<Task>> tempTasksByType = {
      'Daily': await DbService().dbHelper.getTasksByInterval('Daily'),
      'Weekly': await DbService().dbHelper.getTasksByInterval('Weekly'),
      'Monthly': await DbService().dbHelper.getTasksByInterval('Monthly'),
    };

    setState(() {
      _tasksByType = tempTasksByType;
    });
  }

  Future<void> _updateTaskStatus(Task task) async {
    int completed;
    if (task.completed == 1) {
      completed = 0;
    } else {
      completed = 1;
    }

    final newTask = Task(
      id: task.id,
      habitId: task.habitId,
      title: task.title,
      completed: completed,
      startTime: task.startTime,
    );

    try {
      //await dbHelper.updateTask(newTask);
      await DbService().dbHelper.updateTask(newTask);
      await _loadData();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Room updated successfully')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to updated task: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _loadData();
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (_) => [], // you can enhance this later
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTaskList('Daily', Colors.blue.shade100),
                  _buildTaskList('Weekly', Colors.green.shade100),
                  _buildTaskList('Monthly', Colors.orange.shade100),
                ],
              ),
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

  Widget _buildTaskList(String type, Color color) {
    final tasks = _tasksByType[type] ?? [];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Changed from Expanded to prevent fixed height
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              type,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Using a Column instead of ListView with Expanded
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              children: [
                Checkbox(
                  value: task.completed == 1,
                  onChanged: (_) => _updateTaskStatus(task),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      decoration: task.completed == 1
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
          // Add some padding at the bottom
          SizedBox(height: 8),
        ],
      ),
    );
  }

  void _addTaskDialog() {
    TextEditingController _controller = TextEditingController();
    String selectedType = 'daily';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Habit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enter habit name"),
            ),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (val) => setState(() => selectedType = val!),
              items: ['daily', 'weekly', 'monthly']
                  .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t[0].toUpperCase() + t.substring(1)),
              ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                //_addTask(selectedType, _selectedDay, _controller.text);
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}








/*
class HabitCalendarScreen extends StatefulWidget {
  @override
  _HabitCalendarScreenState createState() => _HabitCalendarScreenState();
}

class _HabitCalendarScreenState extends State<HabitCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, List<Task>> _tasksByType = {
    'daily': [],
    'weekly': [],
    'monthly': [],
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await DbService().dbHelper.getAllTasks();

    Map<String, List<Task>> tempTasksByType = {
      'Daily': await DbService().dbHelper.getTasksByInterval('Daily'),
      'Weekly': await DbService().dbHelper.getTasksByInterval('Weekly'),
      'Monthly': await DbService().dbHelper.getTasksByInterval('Monthly'),
    };

    setState(() {
      _tasksByType = tempTasksByType;
    });
  }

  Future<void> _updateTaskStatus(Task task) async {
    int completed;
    if (task.completed == 1) {
      completed = 0;
    } else {
      completed = 1;
    }

    final newTask = Task(
      id: task.id,
      habitId: task.habitId,
      title: task.title,
      completed: completed,
      startTime: task.startTime,
    );

    try {
      //await dbHelper.updateTask(newTask);
      await DbService().dbHelper.updateTask(newTask);
      await _loadData();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Room updated successfully')),
      // );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to updated task: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _loadData();
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (_) => [], // you can enhance this later
          ),
          Expanded(
            child: Column(
              children: [
                _buildTaskList('Daily', Colors.blue.shade100),
                _buildTaskList('Weekly', Colors.green.shade100),
                _buildTaskList('Monthly', Colors.orange.shade100),
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

  Widget _buildTaskList(String type, Color color) {
    final tasks = _tasksByType[type] ?? [];

    return Expanded(
      child: Container(
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                type,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.completed == 1,
                          onChanged: (_) => _updateTaskStatus(task),
                          visualDensity: VisualDensity.compact, // tighter checkbox
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 14,
                              decoration: task.completed == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTaskDialog() {
    TextEditingController _controller = TextEditingController();
    String selectedType = 'daily';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Habit"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enter habit name"),
            ),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (val) => setState(() => selectedType = val!),
              items: ['daily', 'weekly', 'monthly']
                  .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t[0].toUpperCase() + t.substring(1)),
              ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                //_addTask(selectedType, _selectedDay, _controller.text);
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}
 */



