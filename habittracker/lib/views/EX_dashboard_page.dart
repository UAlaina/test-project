// import 'package:flutter/material.dart';
// import 'category_page.dart';
//
// class Category {
//   String id;
//   String name;
//   int activitiesCount;
//
//   Category({
//     required this.id,
//     required this.name,
//     this.activitiesCount = 0,
//   });
// }
//
// class Habit {
//   String id;
//   String name;
//   bool isDaily;
//   int progress;
//   String categoryId;
//
//   Habit({
//     required this.id,
//     required this.name,
//     required this.isDaily,
//     this.progress = 0,
//     required this.categoryId,
//   });
// }
//
// class DashboardPage extends StatefulWidget {
//   const DashboardPage({Key? key}) : super(key: key);
//
//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   final List<Category> _categories = [];
//   int weeklyProgress = 60;
//
//   void _addCategory() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String newCategoryName = '';
//         return AlertDialog(
//           title: const Text('Add New Category'),
//           content: TextField(
//             autofocus: true,
//             decoration: const InputDecoration(
//               labelText: 'Category Name',
//               hintText: 'Enter a category name',
//             ),
//             onChanged: (value) {
//               newCategoryName = value;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (newCategoryName.isNotEmpty) {
//                   setState(() {
//                     _categories.add(
//                       Category(
//                         id: DateTime.now().toString(),
//                         name: newCategoryName,
//                       ),
//                     );
//                   });
//                   Navigator.pop(context);
//                 }
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _openCategoryPage(Category category) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CategoryPage(category: category),
//       ),
//     ).then((value) {
//       // Update the category count if needed when returning from CategoryPage
//       setState(() {});
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Dashboard'),
//         backgroundColor: Colors.lightBlue,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.account_circle_outlined),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               color: Colors.grey[400],
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Weekly status',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     LinearProgressIndicator(
//                       value: weeklyProgress / 100,
//                       backgroundColor: Colors.lightBlue[200],
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//                       minHeight: 10,
//                     ),
//                     const SizedBox(height: 6),
//                     LinearProgressIndicator(
//                       value: weeklyProgress / 100,
//                       backgroundColor: Colors.lightBlue[200],
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//                       minHeight: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: _categories.isEmpty
//                   ? const Center(
//                 child: Text(
//                   'No categories yet.\nAdd one using the + button below.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               )
//                   : GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: _categories.length,
//                 itemBuilder: (ctx, index) {
//                   return GestureDetector(
//                     onTap: () => _openCategoryPage(_categories[index]),
//                     child: Card(
//                       color: Colors.grey[300],
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               _categories[index].name,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               '${_categories[index].activitiesCount} activities',
//                               style: TextStyle(
//                                 color: Colors.grey[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addCategory,
//         backgroundColor: Colors.grey[400],
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }