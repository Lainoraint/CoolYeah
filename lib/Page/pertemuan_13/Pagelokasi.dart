import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pagelokasi extends StatefulWidget {
  const Pagelokasi({super.key});

  @override
  State<Pagelokasi> createState() => _PagelokasiState();
}

class _PagelokasiState extends State<Pagelokasi> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Aktifkan JavaScript
      ..loadRequest(Uri.parse(
          'https://www.google.com/maps/place/PSDKU+Politeknik+Negeri+Malang+di+Kota+Kediri/@-7.8025621,111.9772606,17z/data=!3m1!4b1!4m6!3m5!1s0x2e7856c8ee550497:0x3f8ff2e0bc9b9718!8m2!3d-.8025674!4d111.9798355!16s%2Fg%2F11c6f2rz1c?entry=ttu')); // URL untuk dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller), // Widget WebView
    );
  }
}
