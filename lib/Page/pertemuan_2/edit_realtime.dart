import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditRealtime extends StatefulWidget {
  final String noteId;
  final String currentTitle;
  final String currentDescription;

  const EditRealtime({
    required this.noteId,
    required this.currentTitle,
    required this.currentDescription,
    super.key,
  });

  @override
  State<EditRealtime> createState() => _EditRealtimeState();
}

class _EditRealtimeState extends State<EditRealtime> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('Notes');
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descriptionController =
        TextEditingController(text: widget.currentDescription);
  }

  void _updateNote() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      _databaseReference.child(widget.noteId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
      }).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Note Updated')));
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateNote,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
