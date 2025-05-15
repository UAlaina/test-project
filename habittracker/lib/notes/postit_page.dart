import 'package:flutter/material.dart';

class PostItCanvasPage extends StatefulWidget {
  @override
  _PostItCanvasPageState createState() => _PostItCanvasPageState();
}

class _PostItCanvasPageState extends State<PostItCanvasPage> {
  List<Widget> stickyNotes = [];

  void _addStickyNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String text = "";
        return AlertDialog(
          title: Text("Add Sticky Note"),
          content: TextField(
            onChanged: (value) {
              text = value;
            },
            decoration: InputDecoration(
              hintText: "Enter text for the sticky note",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  stickyNotes.add(
                    ResizableStickyNote(
                      initialOffset: Offset(100, 100),
                      initialSize: Size(120, 100),
                      color: Colors.primaries[stickyNotes.length % Colors.primaries.length][200]!,
                      text: text,
                    ),
                  );
                });
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post-It Canvas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStickyNote,
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: stickyNotes,
      ),
    );
  }
}

class ResizableStickyNote extends StatefulWidget {
  final Offset initialOffset;
  final Size initialSize;
  final Color color;
  final String text;

  ResizableStickyNote({
    required this.initialOffset,
    required this.initialSize,
    required this.color,
    required this.text,
  });

  @override
  _ResizableStickyNoteState createState() => _ResizableStickyNoteState();
}

class _ResizableStickyNoteState extends State<ResizableStickyNote> {
  late Offset offset;
  late Size size;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
    size = widget.initialSize;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset += details.delta;
          });
        },
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Resize handle
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    size = Size(
                      size.width + details.delta.dx,
                      size.height + details.delta.dy,
                    );
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.zoom_out_map,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}