import 'package:flutter/material.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_11/admin/update.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Read extends StatefulWidget {
  const Read({super.key});

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  String userRole = '';
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Users');
  final TextEditingController _phoneController = TextEditingController();
  Map<String, String>? userData;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Retrieve the role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userRole = userDoc['role'] ??
              'user'; // Default to 'user' if role doesn't exist
        });
      }
    }
  }

  Future<void> searchPhoneNumber(String phoneNumber) async {
    setState(() {
      isLoading = true;
      error = null;
      userData = null;
    });

    try {
      // Get all users and filter locally
      final DataSnapshot snapshot = await _database.get();

      if (snapshot.exists && snapshot.value != null) {
        final Map<dynamic, dynamic> allUsers =
            snapshot.value as Map<dynamic, dynamic>;

        // Find the user with matching phone number
        final matchingEntry = allUsers.entries.firstWhere(
          (entry) => (entry.value as Map)['no_hp'] == phoneNumber,
          orElse: () => MapEntry('', {}),
        );

        if (matchingEntry.key.isNotEmpty) {
          final Map<dynamic, dynamic> data = matchingEntry.value;
          setState(() {
            userData = {
              "noteid": matchingEntry.key,
              "name": data['nama'] ?? '',
              "operator": data['operator'] ?? '',
              "location": data['lokasi'] ?? '',
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
            // Header with image and title
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
                        'TRUECALLER',
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
                    'SEARCH ANY PHONE NUMBER',
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
            // Phone number input
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
            // Search results
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
                  width: double.infinity, // Ensure container takes full width
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildResultRow('Name', userData!['name']!),
                      const SizedBox(height: 10),
                      buildResultRow('Operator', userData!['operator']!),
                      const SizedBox(height: 10),
                      buildResultRow('Location', userData!['location']!),
                      const SizedBox(height: 20),
                      if (userRole == 'admin') ...[
                        Center(
                          // Center widget added here
                          child: SizedBox(
                            // SizedBox to control button width
                            width: 200, // Set a fixed width for the button
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Update(
                                      noteid: userData!['noteid']!,
                                      selectednama: userData!['name']!,
                                      selectedoperator: userData!['operator']!,
                                      selectedlokasi: userData!['location']!,
                                      selectednohp: userData!['phone']!,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B79E4),
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
                                'Edit Data',
                                style: TextStyle(
                                  fontFamily: 'Argone',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
