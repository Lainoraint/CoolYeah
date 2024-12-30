import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class FirebaseStoragePage extends StatefulWidget {
  const FirebaseStoragePage({super.key});

  @override
  State<FirebaseStoragePage> createState() => _FirebaseStoragePageState();
}

class _FirebaseStoragePageState extends State<FirebaseStoragePage> {
  File? selectedFile;
  String fileName = '';
  String fileType = '';
  List<Map<String, String>> uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadExistingFiles();
  }

  Future<void> _loadExistingFiles() async {
    final storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('uploads');
    try {
      final listResult = await storageRef.listAll();

      for (var item in listResult.items) {
        String fileUrl = await item.getDownloadURL();
        String fileName = item.name;

        String fileType = '';
        if (fileName.toLowerCase().endsWith('.jpg') ||
            fileName.toLowerCase().endsWith('.jpeg') ||
            fileName.toLowerCase().endsWith('.png')) {
          fileType = 'Image';
        } else if (fileName.toLowerCase().endsWith('.pdf')) {
          fileType = 'PDF';
        } else if (fileName.toLowerCase().endsWith('.doc') ||
            fileName.toLowerCase().endsWith('.docx')) {
          fileType = 'Word';
        } else if (fileName.toLowerCase().endsWith('.mp4')) {
          fileType = 'Video';
        }

        setState(() {
          uploadedFiles.add({
            'fileName': fileName,
            'fileType': fileType,
            'fileUrl': fileUrl,
          });
        });
      }
    } catch (e) {
      print("Error loading existing files: $e");
      _showErrorDialog("Error loading files", e.toString());
    }
  }

  Future<void> selectFile(String type) async {
    FilePickerResult? result;

    try {
      if (type == 'Image') {
        result = await FilePicker.platform.pickFiles(type: FileType.image);
      } else if (type == 'PDF') {
        result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
      } else if (type == 'Word') {
        result = await FilePicker.platform.pickFiles(
            type: FileType.custom, allowedExtensions: ['doc', 'docx']);
      } else if (type == 'Video') {
        result = await FilePicker.platform.pickFiles(type: FileType.video);
      }

      if (result != null) {
        setState(() {
          selectedFile = File(result!.files.single.path!);
          fileName = result.files.single.name;
          fileType = type;
        });
      }
    } catch (e) {
      _showErrorDialog("Error selecting file", e.toString());
    }
  }

  Future<void> uploadFile() async {
    if (selectedFile == null) return;

    try {
      final fileRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('uploads/$fileName');

      await fileRef.putFile(selectedFile!);
      String fileUrl = await fileRef.getDownloadURL();

      setState(() {
        uploadedFiles.add({
          'fileName': fileName,
          'fileType': fileType,
          'fileUrl': fileUrl,
        });
        selectedFile = null;
        fileName = '';
        fileType = '';
      });
    } catch (e) {
      _showErrorDialog("Error uploading file", e.toString());
    }
  }

  Future<void> _launchURL(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      _showErrorDialog("Error opening URL", e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Storage"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () => selectFile("Image"),
                    child: const Text("Image")),
                ElevatedButton(
                    onPressed: () => selectFile("PDF"),
                    child: const Text("PDF")),
                ElevatedButton(
                    onPressed: () => selectFile("Word"),
                    child: const Text("Word")),
                ElevatedButton(
                    onPressed: () => selectFile("Video"),
                    child: const Text("Video"))
              ],
            ),
            const SizedBox(height: 10),
            Text(fileName.isNotEmpty ? fileName : "No file selected"),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: selectedFile != null ? uploadFile : null,
                child: const Text("Upload File")),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: uploadedFiles.length,
                itemBuilder: (context, index) {
                  final fileType = uploadedFiles[index]['fileType'];
                  final fileUrl = uploadedFiles[index]['fileUrl']!;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fileType == 'Image'
                            ? Image.network(
                                fileUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              )
                            : const Icon(
                                Icons.insert_drive_file,
                                size: 40,
                              ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'File Name: ${uploadedFiles[index]['fileName']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text('File Type: $fileType'),
                              GestureDetector(
                                onTap: () => _launchURL(fileUrl),
                                child: Text(
                                  'File Url: $fileUrl',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
