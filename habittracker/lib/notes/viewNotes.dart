import 'package:flutter/material.dart';

class ViewNotePage extends StatelessWidget {
  final String title;
  final String content;

  const ViewNotePage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.green[700]),
        ),
      ),
    );
  }
}