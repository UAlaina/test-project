import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/notes/summarizeText.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/models/user_data.dart';

class AddNotePage extends StatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  AddNotePage({this.noteId, this.initialTitle, this.initialContent});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  String? summary = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle ?? '');
    contentController = TextEditingController(text: widget.initialContent ?? '');

    // Debug print to verify data is being passed correctly
    print('Initial title: ${widget.initialTitle}');
    print('Initial content: ${widget.initialContent}');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> handleSummarize() async {
    if (contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some text to summarize')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await summarizeText(contentController.text);
      setState(() {
        summary = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error summarizing: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final docId = Provider.of<UserData>(context, listen: false).docId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? 'Add Note' : 'Edit Note'),
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
            SizedBox(height: 12),

            // Summarize button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: handleSummarize,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Summarize Text'),
            ),

            SizedBox(height: 16),

            // Show summary if available
            if (summary != null && summary!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Summary:\n$summary',
                  style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold),
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
                if (docId != null && docId.isNotEmpty) {
                  final noteData = {
                    'title': titleController.text,
                    'content': contentController.text,
                    'updated_at': FieldValue.serverTimestamp(),
                  };

                  if (widget.noteId == null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(docId)
                        .collection('notes')
                        .add(noteData);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(docId)
                        .collection('notes')
                        .doc(widget.noteId)
                        .update(noteData);
                  }
                  Navigator.pop(context, true);
                }
              },
              child: Text(widget.noteId == null ? 'Save Note' : 'Update Note'),
            ),
          ],
        ),
      ),
    );
  }
}