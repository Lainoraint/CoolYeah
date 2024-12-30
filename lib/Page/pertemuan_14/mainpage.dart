import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class UserData {
  final String name;
  final int age;
  UserData(this.name, this.age);
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('users');
  List<UserData> _userData = [];
  bool _isAscending = true;
  int? _sortedColumnIndex;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _userData = data.entries
              .map(
                  (entry) => UserData(entry.value['nama'], entry.value['umur']))
              .toList();
        });
      }
    });
  }

  Future<void> _exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              pw.Text("Laporan data user", style: pw.TextStyle(fontSize: 20)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['nama', 'umur'],
                data: _userData.map((user) => [user.name, user.age]).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void _sortByName() {
    setState(() {
      if (_sortedColumnIndex == 0) {
        _isAscending = !_isAscending;
      } else {
        _isAscending = true; // Default ke ascending saat mengganti kolom
      }
      _sortedColumnIndex = 0;
      _userData.sort((a, b) =>
          _isAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    });
  }

  void _sortByAge() {
    setState(() {
      if (_sortedColumnIndex == 1) {
        _isAscending = !_isAscending;
      } else {
        _isAscending = true; // Default ke ascending saat mengganti kolom
      }
      _sortedColumnIndex = 1;
      _userData.sort((a, b) =>
          _isAscending ? a.age.compareTo(b.age) : b.age.compareTo(a.age));
    });
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _userData
        .map((user) => BarChartGroupData(
              x: _userData.indexOf(user),
              barRods: [
                BarChartRodData(toY: user.age.toDouble(), color: Colors.blue)
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                barGroups: _buildBarGroups(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < _userData.length) {
                          return Text(
                            _userData[value.toInt()].name,
                            style: TextStyle(fontSize: 10),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _exportToPDF,
            child: Text('Export to PDF'),
          ),
          Expanded(
            child: DataTable(
              sortAscending: _isAscending,
              sortColumnIndex: _sortedColumnIndex,
              columns: [
                DataColumn(
                  label: Row(
                    children: [
                      Text('Name'),
                      if (_sortedColumnIndex == 0) ...[],
                    ],
                  ),
                  onSort: (columnIndex, _) => _sortByName(),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Text('Age'),
                      if (_sortedColumnIndex == 1) ...[],
                    ],
                  ),
                  onSort: (columnIndex, _) => _sortByAge(),
                ),
              ],
              rows: _userData.map((user) {
                return DataRow(cells: [
                  DataCell(Text(user.name)),
                  DataCell(Text(user.age.toString())),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
