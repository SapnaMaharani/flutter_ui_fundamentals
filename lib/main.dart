import 'package:flutter/material.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Tahap1()));

class Tahap1 extends StatefulWidget {
  const Tahap1({super.key});
  @override
  State<Tahap1> createState() => _Tahap1State();
}

class _Tahap1State extends State<Tahap1> {
  bool isFavorite = false; // Contoh Local State

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 1')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            title: const Text('Pemrograman Mobile'),
            trailing: IconButton(
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              onPressed: () => setState(() => isFavorite = !isFavorite), // Mengubah local state
            ),
          ),
        ],
      ),
    );
  }
}