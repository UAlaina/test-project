import 'package:flutter/material.dart';

class MorningWorkoutPage extends StatefulWidget {
  @override
  _MorningWorkoutPageState createState() => _MorningWorkoutPageState();
}

class _MorningWorkoutPageState extends State<MorningWorkoutPage> {
  final List<Map<String, dynamic>> workouts = [];
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  void _addWorkout() {
    if (_exerciseController.text.isNotEmpty &&
        _repsController.text.isNotEmpty &&
        _timeController.text.isNotEmpty) {
      setState(() {
        workouts.add({
          'exercise': _exerciseController.text,
          'reps': _repsController.text,
          'time': _timeController.text,
          'completed': false,
        });
      });
      _exerciseController.clear();
      _repsController.clear();
      _timeController.clear();
      Navigator.pop(context);
    }
  }

  void _deleteWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
  }

  void _showAddWorkoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Workout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _exerciseController,
              decoration: InputDecoration(labelText: 'Exercise'),
            ),
            TextField(
              controller: _repsController,
              decoration: InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time (e.g., 30 sec)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addWorkout,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Morning Workout'),
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Checkbox(
                value: workout['completed'],
                onChanged: (bool? value) {
                  setState(() {
                    workout['completed'] = value;
                  });
                },
              ),
              title: Text(workout['exercise']),
              subtitle: Text('${workout['reps']} x ${workout['time']}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteWorkout(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWorkoutDialog,
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
      ),
    );
  }
}