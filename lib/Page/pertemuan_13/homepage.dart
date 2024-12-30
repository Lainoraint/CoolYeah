import 'package:flutter/material.dart';
import 'webviewpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      url: 'https://www.tiktok.com',
                      title: 'TikTok',
                    ),
                  ),
                );
              },
              child: const Text('Tiktok'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      url: 'https://www.youtube.com',
                      title: 'YouTube',
                    ),
                  ),
                );
              },
              child: const Text('Youtube'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WebViewPage(
                      url: 'https://web.whatsapp.com/',
                      title: 'Send Message',
                    ),
                  ),
                );
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
