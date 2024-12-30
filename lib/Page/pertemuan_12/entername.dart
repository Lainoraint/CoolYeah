import 'package:flutter/material.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_12/chat.dart';

class Entername extends StatefulWidget {
  const Entername({super.key});

  @override
  State<Entername> createState() => _EnternameState();
}

class _EnternameState extends State<Entername> {
  final TextEditingController _nameController = TextEditingController();

  void _goToChatPage() {
    if (_nameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Chat(senderName: _nameController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Your Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToChatPage,
              child: Text('Enter Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
