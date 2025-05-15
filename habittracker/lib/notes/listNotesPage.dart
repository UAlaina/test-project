import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habittracker/notes/addnotes_page.dart';
import 'package:provider/provider.dart';
import 'package:habittracker/models/user_data.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<Map<String, dynamic>>? _notes = [];
  List<Map<String, dynamic>>? _filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterNotes);
    Future.microtask(() => _loadNotes());
  }

  Future<void> _loadNotes() async {
    final docId = Provider.of<UserData>(context, listen: false).docId;

    if (docId == null || docId.isEmpty) {
      print('Error: docId is null or empty');
      return;
    }

    try {
      final notesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .collection('notes')
          .get();

      final notes = notesSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      setState(() {
        _notes = notes;
        _filteredNotes = List.from(notes);
      });
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  void _filterNotes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotes = _notes?.where((note) {
        final title = (note['title'] ?? '').toLowerCase();
        final content = (note['content'] ?? '').toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    });
  }

  void _navigateToAddNotePage() async {
    final shouldReload = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage()),
    );

    if (shouldReload == true) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search notes...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: _filteredNotes == null || _filteredNotes!.isEmpty
          ? Center(
        child: Text(
          'No notes found',
          style: TextStyle(color: Colors.teal[700], fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _filteredNotes!.length,
        itemBuilder: (context, index) {
          final note = _filteredNotes![index];
          return GestureDetector(
            onTap: () => print('View note details for: ${note['id']}'),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note['title'] ?? 'Untitled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  if (note['content'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        note['content'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.teal[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNotePage,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}