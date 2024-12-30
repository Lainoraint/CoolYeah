import 'package:flutter/material.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_13/Pageinfo.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_13/Pagelokasi.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_13/Pageshop.dart';
import 'package:muhammad_idham_2231730135/Page/pertemuan_13/homepage.dart';

class Mainweb extends StatefulWidget {
  const Mainweb({super.key});

  @override
  State<Mainweb> createState() => _MainwebState();
}

class _MainwebState extends State<Mainweb> {
  int _currentIndex = 0; // Index tab aktif

  // Daftar widget untuk setiap halaman/tab
  final List<Widget> _pages = [
    Homepage(),
    Pagelokasi(),
    Pageshop(),
    Pageinfo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PML 13'),
      ),
      body: _pages[_currentIndex], // Menampilkan halaman sesuai index

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Index tab aktif
        backgroundColor: Colors.blue[50], // Background BottomNavigationBar
        selectedItemColor: Colors.blue, // Warna tab aktif
        unselectedItemColor: Colors.grey, // Warna tab tidak aktif
        type: BottomNavigationBarType.fixed, // Jarak item sama rata
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Ubah index saat tab di-tap
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Lokasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
