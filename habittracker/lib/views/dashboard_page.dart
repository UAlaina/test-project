// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:habittracker/Views/profile_page.dart';
// import 'package:habittracker/Models/dbHelper.dart';
//
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   final DbHelper dbHelper = DbHelper();
//   List<Habit> habits = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//     _addHabitDebug();
//   }
//
//   Future<void> _loadData() async {
//     try {
//       final loadedHabits = await dbHelper.getHabits();
//       setState(() {
//         habits = loadedHabits;
//       });
//     } catch (e) {
//       print('Error loading habits: $e');
//     }
//   }
//
//
//   //INSERT
//   Future<void> _addHabitDebug() async {
//
//     final habit = Habit(
//       id: 0, //is ignored, should auto increment
//       name: 'note',
//       repeatOn: 'week',
//     );
//
//     try {
//       await dbHelper.insertHabit(habit);
//       //should clear all text controllers
//       //clear();
//       await _loadData();
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
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: habits.length,
//                 itemBuilder: (context, index) {
//                   final room = habits[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     child: Padding( // Ensures ListTile has enough space
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: ListTile(
//                               title: Text(room.name),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('id: ${room.id}'),
//                                   Text('name: ${room.name}'),
//                                   Text('repeatOn: ${room.repeatOn}'),
//                                 ],
//                               ),
//                               //EXTRA
//                               // onTap: () {
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(content: Text('SSN: ${room.ssn}')),
//                               //   );
//                               // },
//                             ),
//                           ),
//
//                           //buttons
//                           Column(
//                             //mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 icon: Icon(Icons.edit, color: Colors.green),
//                                 onPressed: () {
//                                   ///displayCurrentUpdating(room);
//                                 },
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.pink),
//                                 onPressed: () {
//                                   //_deleteRoom(room.id!)
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//
//                 },
//               ),
//             ),
//
//
//           ]
//         ),
//       ),
//     );
//   }
// }
