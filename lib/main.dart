import 'package:flutter/material.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

// PERBAIKAN: Kata 'const' dihilangkan sebelum MaterialApp
void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Tahap4ValueNotifier()));

class Tahap4ValueNotifier extends StatelessWidget {
  Tahap4ValueNotifier({super.key});

  // 1. Buat ValueNotifier untuk nilai sederhana
  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4: ValueNotifier')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            
            // 2. Tampilkan nilai dengan ValueListenableBuilder
            ValueListenableBuilder<int>(
              valueListenable: favoriteCount,
              builder: (context, value, child) {
                return Text(
                  'Total Favorite: $value',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // 3. Tambahkan button yang mengubah value
            ElevatedButton(
              onPressed: () {
                favoriteCount.value++; 
              },
              child: const Text('Tambah Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}