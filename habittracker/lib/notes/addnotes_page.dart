import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/models/user_data.dart';

class AddNotePage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final docId =
                    Provider.of<UserData>(context, listen: false).docId;

                if (docId != null && docId.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(docId)
                      .collection('notes')
                      .add({
                    'title': _titleController.text,
                    'content': _contentController.text,
                    'created_at': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context, true);
                } else {
                  print('Error: User docId is null or empty.');
                }
              },
              child: Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}