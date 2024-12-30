import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Delete extends StatefulWidget {
  const Delete({super.key});

  @override
  State<Delete> createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Users');
  final TextEditingController _phoneController = TextEditingController();
  Map<String, String>? userData;
  bool isLoading = false;
  String? error;

  Future<void> searchPhoneNumber(String phoneNumber) async {
    setState(() {
      isLoading = true;
      error = null;
      userData = null;
    });

    try {
      final DataSnapshot snapshot = await _database.get();

      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> allUsers =
            snapshot.value as Map<dynamic, dynamic>;

        final matchingEntry = allUsers.entries.firstWhere(
          (entry) => (entry.value as Map)['no_hp'] == phoneNumber,
          orElse: () => MapEntry('', {}),
        );

        if (matchingEntry.key.isNotEmpty) {
          final Map<dynamic, dynamic> data = matchingEntry.value;
          setState(() {
            userData = {
              "noteid": matchingEntry.key,
              "phone": data['no_hp'] ?? '',
            };
          });
        } else {
          setState(() {
            error = 'No user found with this phone number';
          });
        }
      } else {
        setState(() {
          error = 'No data available';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error searching for user: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deletePhoneNumber(String noteId) async {
    try {
      await _database.child(noteId).remove();
      setState(() {
        userData = null;
        _phoneController.clear();
      });
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting phone number: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB6C7F7),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB6C7F7), Color(0xFFFBE0)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFFB6C7F7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://img.icons8.com/ios/50/cat.png',
                        height: 50,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'PHONE SEARCH',
                        style: TextStyle(
                          fontFamily: 'Argone',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'SEARCH AND DELETE PHONE NUMBERS',
                    style: TextStyle(
                      fontFamily: 'Argone',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Search input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B79E4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                    ),
                    onPressed: () {
                      if (_phoneController.text.isNotEmpty) {
                        searchPhoneNumber(_phoneController.text);
                      }
                    },
                    child: const Text(
                      'SEARCH',
                      style: TextStyle(
                        fontFamily: 'Argone',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Search results and delete button
            if (isLoading)
              const CircularProgressIndicator()
            else if (error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (userData != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Phone Number: ${userData!['phone']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this phone number?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      deletePhoneNumber(userData!['noteid']!);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 40,
                          ),
                        ),
                        child: const Text(
                          'Delete Number',
                          style: TextStyle(
                            fontFamily: 'Argone',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
