import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pageinfo extends StatefulWidget {
  const Pageinfo({super.key});

  @override
  State<Pageinfo> createState() => _PageinfoState();
}

class _PageinfoState extends State<Pageinfo> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Aktifkan JavaScript
      ..loadRequest(Uri.parse(
          'https://id.wikipedia.org/wiki/Politeknik_Negeri_Malang#:~:text=Politeknik%20Negeri%20Malang%2C%20disingkat%20POLINEMA,pekerjaan%20dengan%20keahlian%20terapan%20tertentu'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller), // Widget WebView
    );
  }
}
