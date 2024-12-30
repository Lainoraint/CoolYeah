import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_11/landing.dart';

class Update extends StatefulWidget {
  final String noteid;
  final String selectednama;
  final String selectedoperator;
  final String selectedlokasi;
  final String selectednohp;

  const Update(
      {required this.noteid,
      required this.selectednama,
      required this.selectedoperator,
      required this.selectedlokasi,
      required this.selectednohp,
      super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  late TextEditingController _textnama = TextEditingController();
  late TextEditingController _textoperator = TextEditingController();
  late TextEditingController _textlokasi = TextEditingController();
  late TextEditingController _textnohp = TextEditingController();
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('Users');
  @override
  void initState() {
    super.initState();
    _textnama = TextEditingController(text: widget.selectednama);
    _textoperator = TextEditingController(text: widget.selectedoperator);
    _textlokasi = TextEditingController(text: widget.selectedlokasi);
    _textnohp = TextEditingController(text: widget.selectednohp);
  }

  void _updateUsers() {
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
    _databaseReference.child(widget.noteid).update({
      'nama': _textnama.text,
      'operator': _textoperator.text,
      'lokasi': _textlokasi.text,
      'no_hp': _textnohp.text,
    }).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Data telah diupdate')));
      _textnama.clear();
      _textoperator.clear();
      _textlokasi.clear();
      _textnohp.clear();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Landing()));
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        "Update\nPhone Number",
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
                          elevation: 5,
                        ),
                        onPressed: _updateUsers,
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
          // Back button positioned at top left
          Positioned(
            top: 40, // Adjust this value to position the button vertically
            left: 20, // Adjust this value to position the button horizontally
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
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
