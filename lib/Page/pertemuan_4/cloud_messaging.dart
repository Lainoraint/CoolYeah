import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CloudMessaging extends StatefulWidget {
  const CloudMessaging({super.key});

  @override
  State<CloudMessaging> createState() => _CloudMessagingState();
}

class _CloudMessagingState extends State<CloudMessaging> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _promoIdController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();
  final TextEditingController _promoUntilController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();

  List<RemoteMessage> _notificationMessages = []; // Store notification messages
  List<RemoteMessage> _dataMessages = []; // Store data messages
  List<String> _subscribedTopics = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    // Subscribe to default topic
    _subscribeToTopic('messaging');
    _initializeNotifications();
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token and store it directly in the controller
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      _tokenController.text = token ?? '';
    });

    // Handle background message opens
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Opened app from background message: ${message.notification?.title}');
      _handleMessage(message);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message: ${message.data}');
      _handleMessage(message);
    });

    // Handle background messages when the app is terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // This method is called when a message is received while the app is in the background or terminated
    print('Handling a background message: ${message.data}');
    // Handle the message here
    _handleMessage(message);
  }

  void clear() {
    _titleController.clear();
    _bodyController.clear();
    _promoController.clear();
    _promoIdController.clear();
    _promoUntilController.clear();
  }

  void _handleMessage(RemoteMessage message) {
    // Handle notification message
    if (message.notification != null) {
      print('Notification Title: ${message.notification?.title}');
      print('Notification Body: ${message.notification?.body}');

      // Fill the title and body TextFields
      setState(() {
        clear();
        _titleController.text = message.notification?.title ?? '';
        _bodyController.text = message.notification?.body ?? '';
      });

      // Add to notification message history
      setState(() {
        _notificationMessages.insert(0, message);
      });
    }

    // Handle data message
    if (message.data.isNotEmpty) {
      print('Data Message: ${message.data}');

      // Fill promo ID, promo, and promo until TextFields
      setState(() {
        clear();
        _promoIdController.text = message.data['promoId'] ?? 'N/A';
        _promoController.text = message.data['promo'] ?? 'N/A';
        _promoUntilController.text = message.data['promoUntil'] ?? 'N/A';
      });

      // Add to data message history
      setState(() {
        _dataMessages.insert(0, message);
      });

      _showNotificationDialogWithData(message.data);
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    if (topic.isEmpty) return;

    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      setState(() {
        if (!_subscribedTopics.contains(topic)) {
          _subscribedTopics.add(topic);
        }
      });
      _showSnackBar('Successfully subscribed to topic: $topic');
    } catch (e) {
      _showSnackBar('Failed to subscribe to topic: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? _getTopicFromMessage(RemoteMessage message) {
    return message.data['topic'] as String?;
  }

  void _showNotificationDialog(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? 'New Message'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(message.notification?.body ?? ''),
              if (message.data.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text('Additional Data:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...message.data.entries.map(
                  (e) => Text('${e.key}: ${e.value}'),
                ),
              ],
              if (_getTopicFromMessage(message) != null) ...[
                const SizedBox(height: 8),
                Text('Topic: ${_getTopicFromMessage(message)}',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _showNotificationWithData(
      String promo, String promoId, String promoUntil) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Today Promo!',
      '$promo $promoUntil',
      platformChannelSpecifics,
    );
  }

  void _showNotificationDialogWithData(Map<String, dynamic> data) {
    String promoId = data['promoId'] ?? 'N/A';
    String promo = data['promo'] ?? 'N/A';
    String promoUntil = data['promoUntil'] ?? 'N/A';

    _showNotificationWithData(promo, promoId, promoUntil);
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _promoIdController.dispose();
    _promoController.dispose();
    _promoUntilController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: readOnly,
          fillColor: readOnly ? Colors.grey[200] : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cloud Messaging"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "DEVICE TOKEN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(_tokenController, 'FCM Token', readOnly: true),
            const SizedBox(height: 20),
            const Text(
              "NOTIFICATION",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(_titleController, 'Title'),
            _buildTextField(_bodyController, 'Body'),
            const SizedBox(height: 20),
            const Text(
              "PROMO DETAILS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTextField(_promoIdController, 'Promo ID'),
            _buildTextField(_promoController, 'Promo'),
            _buildTextField(_promoUntilController, 'Promo Until'),

            // Message History for Notifications
            if (_notificationMessages.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "NOTIFICATION MESSAGE HISTORY",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notificationMessages.length,
                itemBuilder: (context, index) {
                  final message = _notificationMessages[index];
                  return Card(
                    child: ListTile(
                      title: Text(message.notification?.title ?? 'No Title'),
                      subtitle: Text(message.notification?.body ?? 'No Body'),
                    ),
                  );
                },
              ),
            ],

            // Message History for Data
            if (_dataMessages.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "DATA MESSAGE HISTORY",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dataMessages.length,
                itemBuilder: (context, index) {
                  final message = _dataMessages[index];
                  return Card(
                    child: ListTile(
                      title: Text('Data Message'),
                      subtitle: Text(message.data.toString()),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
