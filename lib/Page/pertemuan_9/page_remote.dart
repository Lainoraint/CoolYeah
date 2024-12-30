import 'dart:async'; // Untuk Timer
import 'package:flutter/material.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_9/remote_config.dart';

class PageRemote extends StatefulWidget {
  const PageRemote({super.key});

  @override
  State<PageRemote> createState() => _PageRemoteState();
}

class _PageRemoteState extends State<PageRemote> {
  late FirebaseRemoteConfigService _remoteConfigService;
  late Timer _timer; // Timer untuk refresh otomatis

  @override
  void initState() {
    super.initState();
    _remoteConfigService = FirebaseRemoteConfigService();
    _initializeRemoteConfig();

    // Set interval refresh (contoh: setiap 30 detik)
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _fetchRemoteConfig();
    });
  }

  Future<void> _initializeRemoteConfig() async {
    await _remoteConfigService.initialize();
    setState(() {}); // Refresh UI setelah inisialisasi
  }

  Future<void> _fetchRemoteConfig() async {
    await _remoteConfigService.fetchAndActivate();
    setState(() {}); // Refresh UI setelah pembaruan konfigurasi
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontColorHex = _remoteConfigService.fontColor;
    final fontSize = double.tryParse(_remoteConfigService.fontSize) ?? 18.0;
    Color? fontColor;

    try {
      fontColor = Color(int.parse(fontColorHex.replaceFirst('#', '0xff')));
    } catch (e) {
      fontColor = Colors.black; // Default warna jika parsing gagal
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Remote Config"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Text(
          "Teks untuk Test",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Perbarui konfigurasi secara manual
          await _fetchRemoteConfig();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
