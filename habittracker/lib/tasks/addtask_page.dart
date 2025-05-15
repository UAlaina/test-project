import 'package:flutter/material.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/time/date_check_service.dart';

class AddTaskPage extends StatefulWidget {
  final int habitId;

  const AddTaskPage({super.key, required this.habitId});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final DbHelper dbHelper = DbService().dbHelper;
  final TextEditingController titleController = TextEditingController();

  Future<void> _addTask() async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    final currentHabit = await DbService().dbHelper.getHabitById(widget.habitId);

    DateTime now = DateTime.now();
    DateTime alignedTime = now; //placeholder
    switch (currentHabit.repeatOn) {
      case 'Daily':
        //interval = 24 * 60 * 60 * 1000; //24hrs
        alignedTime = DateCheckService.startOfDay(now);
        break;
      case 'Weekly':
        //interval = 7 * 24 * 60 * 60 * 1000; //7days
        alignedTime = DateCheckService.startOfWeek(now);
        break;
      case 'Monthly':
        //interval = 30 * 24 * 60 * 60 * 1000; //30days
        alignedTime = DateCheckService.startOfMonth(now);
        break;
      default:
        print('[!Intervalswitch] wrong value (d|w|m)');
        return;
    }

    final task = Task(
      id: 0, //is ignored, should auto increment
      habitId: widget.habitId,
      title: titleController.text,
      completed: 0,
      startTime: alignedTime.millisecondsSinceEpoch,
    );

    try {
      await DbService().dbHelper.insertTask(task);
      //should clear all text controllers
      //clear();
      //await _loadRooms();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Tasks'),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //name
            _buildTextField('Task Name', titleController),
            SizedBox(height: 16),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _addTask();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HabitlistPage()),
                  // );
                  Navigator.pop(context, true);
                },
                child: Text('Submit', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  //primary: Colors.grey[600],
                  //onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller,  {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }



}

