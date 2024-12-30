import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore extends StatefulWidget {
  const CloudFirestore({super.key});

  @override
  State<CloudFirestore> createState() => _CloudFirestoreState();
}

Future<void> tambahMahasiswa(String nama, String alamat, String nohp) {
  CollectionReference mahasiswa =
      FirebaseFirestore.instance.collection('mahasiswa');

  return mahasiswa
      .add({
        'nama': nama,
        'alamat': alamat,
        'no_hp': nohp,
      })
      .then((value) => print("Data Mahasiswa berhasil ditambahkan!"))
      .catchError((error) => print("Data Mahasiswa gagal ditambahkan: $error"));
}

Future<void> updateDataMahasiswa(
    String idmahasiswa, String newNama, String newAlamat, String newNoHp) {
  CollectionReference mahasiswa =
      FirebaseFirestore.instance.collection('mahasiswa');

  return mahasiswa
      .doc(idmahasiswa)
      .update({
        'nama': newNama,
        'alamat': newAlamat,
        'no_hp': newNoHp,
      })
      .then((value) => print("Data mahasiswa berhasil diperbarui!"))
      .catchError((error) => print("Data mahasiswa gagal diperbarui: $error"));
}

Future<void> hapusdataMahasiswa(String idmahasiswa) {
  CollectionReference mahasiswa =
      FirebaseFirestore.instance.collection('mahasiswa');

  return mahasiswa
      .doc(idmahasiswa)
      .delete()
      .then((value) => print("Data mahasiswa telah berhasil dihapus!"))
      .catchError((error) => print("Data mahasiswa gagal dihapus: $error"));
}

class _CloudFirestoreState extends State<CloudFirestore> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  List<DocumentSnapshot> _mahasiswaList = [];

  @override
  void initState() {
    super.initState();
    _readMahasiswa();
  }

  void _tambahMahasiswa() {
    tambahMahasiswa(
        _namaController.text, _alamatController.text, _nohpController.text);
    _readMahasiswa();
  }

  void _updateNamaMahasiswa() {
    updateDataMahasiswa(_idController.text, _namaController.text,
        _alamatController.text, _nohpController.text);
    _readMahasiswa();
  }

  void _hapusdataMahasiswa() {
    hapusdataMahasiswa(_idController.text);
    _readMahasiswa();
  }

  void _readMahasiswa() {
    CollectionReference mahasiswa =
        FirebaseFirestore.instance.collection('mahasiswa');

    mahasiswa.get().then((QuerySnapshot snapshot) {
      setState(() {
        _mahasiswaList = snapshot.docs;
        _idController.clear();
        _namaController.clear();
        _alamatController.clear();
        _nohpController.clear();
      });
    });
  }

  void _clearMahasiswa() {
    _readMahasiswa();
    _idController.clear();
    _namaController.clear();
    _alamatController.clear();
    _nohpController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(0, 0, 253, 253)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'ID Mahasiswa',
              ),
              readOnly: true,
            ),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
              ),
            ),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
              ),
            ),
            TextField(
              controller: _nohpController,
              decoration: const InputDecoration(
                labelText: 'No HP',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 40.0,
              runSpacing: 20.0,
              children: [
                ElevatedButton(
                  onPressed: _tambahMahasiswa,
                  child: const Text('Tambah'),
                ),
                ElevatedButton(
                  onPressed: _updateNamaMahasiswa,
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _hapusdataMahasiswa,
                  child: const Text('Hapus'),
                ),
                ElevatedButton(
                  onPressed: _clearMahasiswa,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _mahasiswaList.length,
                itemBuilder: (context, index) {
                  var mahasiswa = _mahasiswaList[index];
                  return ListTile(
                    title: Text('Nama  : ${mahasiswa['nama']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alamat  : ${mahasiswa['alamat']}'),
                        Text('No HP   : ${mahasiswa['no_hp'].toString()}'),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _idController.text = mahasiswa.id;
                        _namaController.text = mahasiswa['nama'];
                        _alamatController.text = mahasiswa['alamat'];
                        _nohpController.text = mahasiswa['no_hp'].toString();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
