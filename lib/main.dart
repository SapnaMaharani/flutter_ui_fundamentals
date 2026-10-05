import 'package:flutter/material.dart';

const String studentId = '2415051024';
const String studentName = 'Ni Putu Sapna Maharani';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 9'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            studentCard(studentId, studentName),
            studentCard('2400000001', 'Mahasiswa Contoh 1'),
            studentCard('2400000002', 'Mahasiswa Contoh 2'),
          ],
        ),
      ),
    );
  }
}

Widget studentCard(String nim, String nama) {
  return Card(
    child: ListTile(
      leading: const Icon(Icons.person),
      title: Text(nim),
      subtitle: Text(nama),
    ),
  );
}