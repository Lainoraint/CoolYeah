import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pageshop extends StatefulWidget {
  const Pageshop({super.key});

  @override
  State<Pageshop> createState() => _PageshopState();
}

class _PageshopState extends State<Pageshop> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Aktifkan JavaScript
      ..loadRequest(Uri.parse('https://shopee.co.id')); // URL untuk dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller), // Widget WebView
    );
  }
}
