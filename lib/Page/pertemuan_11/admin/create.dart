import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final TextEditingController _textnama = TextEditingController();
  final TextEditingController _textoperator = TextEditingController();
  final TextEditingController _textlokasi = TextEditingController();
  final TextEditingController _textnohp = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('Users');

  void _addUsers() {
    if (_textnama.text.isEmpty ||
        _textoperator.text.isEmpty ||
        _textlokasi.text.isEmpty ||
        _textnohp.text.isEmpty) {
      // Tampilkan Alert jika ada field kosong
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: const Text("Terdapat kolom yang belum terisi !"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return; // Berhenti di sini jika ada field kosong
    }

    // Jika semua field terisi, lanjutkan menyimpan data
    _databaseReference.push().set({
      'nama': _textnama.text,
      'operator': _textoperator.text,
      'lokasi': _textlokasi.text,
      'no_hp': _textnohp.text,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data telah ditambahkan')));
      _textnama.clear();
      _textoperator.clear();
      _textlokasi.clear();
      _textnohp.clear();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian atas dengan gambar dan judul
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "UPLOAD\nPhone Number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Argone',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Admin Panel",
                      style: TextStyle(
                        fontFamily: 'Argone',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.phone,
                        size: 40,
                        color: Colors.blue.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Formulir input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    buildTextField(_textnama, "Enter name"),
                    const SizedBox(height: 10),
                    buildTextField(_textoperator, "Enter operator"),
                    const SizedBox(height: 10),
                    buildTextField(_textlokasi, "Enter location"),
                    const SizedBox(height: 10),
                    buildTextField(_textnohp, "Enter phone number"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                      ),
                      onPressed: () {
                        _addUsers();
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.blue.shade50,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
