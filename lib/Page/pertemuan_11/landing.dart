import 'package:flutter/material.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_11/admin/create.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_11/admin/delete.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_11/user/read.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100] ?? Colors.blue, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WELCOME BACK',
                style: TextStyle(
                  fontFamily: 'Argone',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'TrueCaller !',
                style: TextStyle(
                  fontFamily: 'Argone',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Admin Panel',
                style: TextStyle(
                  fontFamily: 'Argone',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.phone,
                  size: 40,
                  color: Colors.blue.shade200,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FractionallySizedBox(
                        widthFactor:
                            0.9, // Atur lebar yang sama dengan tombol Upload
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Create()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      textStyle: const TextStyle(
                                          fontFamily: 'Argone',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text("Upload"),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height:
                                    16), // Jarak antara tombol Upload dan Update/Delete
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Read()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.blue),
                                      foregroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      textStyle: const TextStyle(
                                          fontFamily: 'Argone',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text("Update"),
                                  ),
                                ),
                                const SizedBox(width: 16), // Jarak antar tombol
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Delete()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.blue),
                                      foregroundColor: Colors.blue,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      textStyle: const TextStyle(
                                          fontFamily: 'Argone',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: const Text("Delete"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
