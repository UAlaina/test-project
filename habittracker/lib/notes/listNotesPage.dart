// import 'package:flutter/material.dart';
// import 'package:habittracker/notes/addnotes_page.dart';
// import 'package:habittracker/models/notesDbHelper.dart';
//
// class ListNotesPage extends StatefulWidget {
//   const ListNotesPage({super.key});
//
//   @override
//   _ListNotesPageState createState() => _ListNotesPageState();
// }
//
// class _ListNotesPageState extends State<ListNotesPage> {
//   final _dbHelper = NotesDbHelper();
//   List<Note> _notes = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchNotes();
//   }
//
//   void _fetchNotes() async {
//     final notes = await _dbHelper.getNotes();
//     setState(() {
//       _notes = notes;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes List'),
//       ),
//       body: _notes.isEmpty
//           ? Center(child: Text('No notes available.'))
//           : ListView.builder(
//         itemCount: _notes.length,
//         itemBuilder: (context, index) {
//           final note = _notes[index];
//           return ListTile(
//             title: Text(note.title),
//             subtitle: Text(note.description),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddNotePage()),
//           );
//           _fetchNotes();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:habittracker/notes/addnotes_page.dart';
import 'package:habittracker/models/notesDbHelper.dart';

class ListNotesPage extends StatefulWidget {
  const ListNotesPage({super.key});

  @override
  _ListNotesPageState createState() => _ListNotesPageState();
}

class _ListNotesPageState extends State<ListNotesPage> {
  final _dbHelper = NotesDbHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text(
          'Notes List',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _notes.isEmpty
          ? Center(
        child: Text(
          'No notes available.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                note.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          _fetchNotes();
        },
        backgroundColor: Colors.grey[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
