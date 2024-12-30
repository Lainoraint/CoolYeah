import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_2/add_realtime.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_2/edit_realtime.dart';

class Realtime extends StatefulWidget {
  const Realtime({super.key});

  @override
  State<Realtime> createState() => _RealtimeState();
}

class _RealtimeState extends State<Realtime> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('Notes');
  List<Map<String, String>> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() {
    _databaseReference.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final notesList = <Map<String, String>>[];

      if (dataSnapshot.exists) {
        dataSnapshot.children.forEach((childSnapshot) {
          final title = childSnapshot.child('title').value as String?;
          final description =
              childSnapshot.child('description').value as String?;
          final id = childSnapshot.key;

          if (title != null && description != null && id != null) {
            notesList.add({
              'id': id,
              'title': title,
              'description': description,
            });
          }
        });
      }

      setState(() {
        _notes = notesList;
      });
    });
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Apakah anda yakin ingin menghapus data?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNote(id);
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(String id) {
    _databaseReference.child(id).remove().then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Catatan telah dihapus')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return ListTile(
                    title: Text(note['title'] ?? ''),
                    subtitle: Text(note['description'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDelete(note['id']!);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRealtime(
                            noteId: note['id']!,
                            currentTitle: note['title']!,
                            currentDescription: note['description']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddRealtime()),
                );
              },
              child: const Text('Tambah Data'),
            ),
          ],
        ),
      ),
    );
  }
}
