

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:habittracker/models/dbHelper.dart';
import 'package:habittracker/models/db_service.dart';

class AddNewHabitsPage extends StatefulWidget {
  const AddNewHabitsPage({super.key});

  @override
  State<AddNewHabitsPage> createState() => _AddNewHabitsPageState();
}

class _AddNewHabitsPageState extends State<AddNewHabitsPage> {
  final DbHelper dbHelper = DbService().dbHelper;
  final TextEditingController nameController = TextEditingController();
  Map<String, String?> selectedValues = {};

  //NOTIFICATION PART:
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request notification permission on Android 13+
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _showNotification(String habitName) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'habit_reminder_channel',
      'Habit Reminders',
      channelDescription: 'Channel for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'REMINDER',
      habitName,
      platformDetails,
    );
  }
  //NOTIF END

  Future<void> _addHabit() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    final habit = Habit(
      id: 0,
      name: nameController.text,
      repeatOn: selectedValues['Frequency'] ?? 'Weekly',
    );

    try {
      await DbService().dbHelper.insertHabit(habit);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Habit added successfully! 🎉')),
      );
      //NOTIFICATION PART:
      await _showNotification(habit.name);
      print('[!notif] after print');

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add habit: $e')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Habit',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[400],
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Habit Name', nameController),
            SizedBox(height: 20),
            _buildDropdown('Frequency', ['Daily', 'Weekly', 'Monthly', 'Once']),
            SizedBox(height: 20),
            _buildDropdown('Reminder', ['Time', 'Notification']),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _addHabit,
                child: Text('Submit', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.teal[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedValues[label],
            underline: SizedBox(),
            items: options
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedValues[label] = value;
              });
            },
            hint: Text('Select $label'),
          ),
        ),
      ],
    );
  }
}


















// import 'package:flutter/material.dart';
// import 'package:habittracker/habits/habitlist_page.dart';
// import 'package:habittracker/models/dbHelper.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:habittracker/models/db_service.dart';
//
// class AddNewHabitsPage extends StatefulWidget {
//   const AddNewHabitsPage({super.key});
//
//   @override
//   State<AddNewHabitsPage> createState() => _AddNewHabitsPageState();
// }
//
// class _AddNewHabitsPageState extends State<AddNewHabitsPage> {
//   final DbHelper dbHelper = DbService().dbHelper;
//   final TextEditingController nameController = TextEditingController();
//   // String? selectedFrequency;
//   Map<String, String?> selectedValues = {};
//
//   Future<void> _addHabit() async {
//     if (nameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Name cannot be empty')),
//       );
//       return;
//     }
//
//     final habit = Habit(
//       id: 0, //is ignored, should auto increment
//       name: nameController.text,
//       repeatOn: selectedValues['Frequency'] ?? 'Weekly',
//     );
//     //DEBUG
//     // final room = Room(
//     //   id: 0, //should auto increment
//     //   name: 'roy',
//     //   contactPhone: '1234567890',
//     //   ssn: 'irgy7e8pid',
//     //   address: 'beans 123st',
//     // );
//
//     try {
//       //await dbHelper.insertHabit(habit);
//       await DbService().dbHelper.insertHabit(habit);
//       //should clear all text controllers
//       //clear();
//       //await _loadRooms();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Habit added successfully')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add habit: $e')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add New Habits'),
//         backgroundColor: Colors.grey[200],
//         foregroundColor: Colors.black,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //name
//             _buildTextField('Habit Name', nameController),
//             SizedBox(height: 16),
//             // description
//             // _buildTextField('Description', maxLines: 4),
//             // SizedBox(height: 16),
//             _buildDropdown('Frequency', ['Daily', 'Weekly', 'Monthly', 'Once']),
//             SizedBox(height: 16),
//             _buildDropdown('Reminder', ['Time', 'Notification']),
//             Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await _addHabit();
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(builder: (context) => HabitlistPage()),
//                   // );
//                   Navigator.pop(context, true);
//                 },
//                 child: Text('Submit', style: TextStyle(fontSize: 16)),
//                 style: ElevatedButton.styleFrom(
//                   //primary: Colors.grey[600],
//                   //onPrimary: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller,  {int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         SizedBox(height: 8),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildDropdown(String label, List<String> options) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//         SizedBox(height: 8),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButton<String>(
//             isExpanded: true,
//             value: selectedValues[label],
//             underline: SizedBox(),
//             items: options
//                 .map((option) => DropdownMenuItem(
//               value: option,
//               child: Text(option),
//             ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedValues[label] = value;
//               });
//             },
//             hint: Text('Select $label'),
//           ),
//         ),
//       ],
//     );
//   }
//
// }



/*
class AddNewHabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Habits'),
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
            _buildTextField('Habit Name'),
            SizedBox(height: 16),
            _buildTextField('Description', maxLines: 4),
            SizedBox(height: 16),
            _buildDropdown('Frequency', ['Daily', 'Weekly', 'Monthly']),
            SizedBox(height: 16),
            _buildDropdown('Reminder', ['Time', 'Notification']),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {},
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

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        TextField(
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

  Widget _buildDropdown(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: SizedBox(),
            items: options
                .map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            ))
                .toList(),
            onChanged: (value) {},
            hint: Text('Select $label'),
          ),
        ),
      ],
    );
  }
}


<<<<<<< Updated upstream
 */
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:habittracker/models/dbHelper.dart';
// import 'package:habittracker/models/db_service.dart';
//
// class AddNewHabitsPage extends StatefulWidget {
//   const AddNewHabitsPage({super.key});
//
//   @override
//   State<AddNewHabitsPage> createState() => _AddNewHabitsPageState();
// }
//
// class _AddNewHabitsPageState extends State<AddNewHabitsPage> {
//   final DbHelper dbHelper = DbService().dbHelper;
//   final TextEditingController nameController = TextEditingController();
//   Map<String, String?> selectedValues = {};
//
//   //NOTIFICATION PART:
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   @override
//   void initState() {
//     super.initState();
//     _initNotifications();
//   }
//
//   void _initNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> _showNotification(String habitName) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'habit_reminder_channel',
//       'Habit Reminders',
//       channelDescription: 'Channel for habit reminders',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformDetails =
//     NotificationDetails(android: androidDetails);
//
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'REMINDER',
//       habitName,
//       platformDetails,
//     );
//   }
//
//   Future<void> _addHabit() async {
//     if (nameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Name cannot be empty')),
//       );
//       return;
//     }
//
//     final habit = Habit(
//       id: 0,
//       name: nameController.text,
//       repeatOn: selectedValues['Frequency'] ?? 'Weekly',
//     );
//
//     try {
//       await DbService().dbHelper.insertHabit(habit);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Habit added successfully! 🎉')),
//       );
//       //NOTIFICATION PART:
//       await _showNotification(habit.name);
//
//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add habit: $e')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Add New Habit',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.teal[400],
//         foregroundColor: Colors.white,
//         elevation: 5,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTextField('Habit Name', nameController),
//             SizedBox(height: 20),
//             _buildDropdown('Frequency', ['Daily', 'Weekly', 'Monthly', 'Once']),
//             SizedBox(height: 20),
//             _buildDropdown('Reminder', ['Time', 'Notification']),
//             Spacer(),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _addHabit,
//                 child: Text('Submit', style: TextStyle(fontSize: 18)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal[600],
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller,
//       {int maxLines = 1}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//               fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.teal[50],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdown(String label, List<String> options) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 8),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButton<String>(
//             isExpanded: true,
//             value: selectedValues[label],
//             underline: SizedBox(),
//             items: options
//                 .map(
//                   (option) => DropdownMenuItem(
//                 value: option,
//                 child: Text(option),
//               ),
//             )
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedValues[label] = value;
//                 if (value == 'Notification') {
//                   _showNotification('Time to focus on your habit!');
//                 }
//               });
//             },
//             hint: Text('Select $label'),
//           ),
//         ),
//       ],
//     );
//   }
// }
