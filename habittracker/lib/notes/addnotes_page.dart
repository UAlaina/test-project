import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/models/user_data.dart';

class AddNotePage extends StatelessWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  AddNotePage({this.noteId, this.initialTitle, this.initialContent});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: initialTitle);
    final contentController = TextEditingController(text: initialContent);

    return Scaffold(
      appBar: AppBar(
        title: Text(noteId == null ? 'Add Note' : 'Edit Note'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.green[700]),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.green[700]),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final docId = Provider.of<UserData>(context, listen: false).docId;

                if (docId != null && docId.isNotEmpty) {
                  final noteData = {
                    'title': titleController.text,
                    'content': contentController.text,
                    'updated_at': FieldValue.serverTimestamp(),
                  };

                  if (noteId == null) {
                    // Add new note
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(docId)
                        .collection('notes')
                        .add(noteData);
                  } else {
                    // Update existing note
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(docId)
                        .collection('notes')
                        .doc(noteId)
                        .update(noteData);
                  }
                  Navigator.pop(context, true);
                }
              },
              child: Text(noteId == null ? 'Save Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}