import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddRealtime extends StatefulWidget {
  const AddRealtime({super.key});

  @override
  State<AddRealtime> createState() => _AddRealtimeState();
}

class _AddRealtimeState extends State<AddRealtime> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('Notes');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addNote() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      _databaseReference.push().set({
        'title': _titleController.text,
        'description': _descriptionController.text,
      }).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Note Added')));
        _titleController.clear();
        _descriptionController.clear();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
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
              onPressed: _addNote,
              child: const Text('Add Note'),
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
