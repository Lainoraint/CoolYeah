import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_9/remote_config.dart';
import 'package:muhammad_idham_2231730135/home.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseRemoteConfigService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2231730135_Muhammad_Idham',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 41, 169, 201)),
        useMaterial3: true,
      ),
      home: const Home(title: '2231730135_Muhammad_Idham'),
    );
  }
}
