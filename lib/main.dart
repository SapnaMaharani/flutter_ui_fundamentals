import 'package:flutter/material.dart';

const nim = '2415051024';
const nama = 'Ni Putu Sapna Maharani';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: DebuggingPage(),
));

class DebuggingPage extends StatelessWidget {
  const DebuggingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 16 Debugging')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              '$nim - $nama',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text('Kasus A - Row Overflow'),
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$nim - $nama - teks sangat panjang agar tidak overflow',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const Divider(),

            const Text('Kasus B - ListView dalam Column'),
            SizedBox(
              height: 120,
              child: ListView(
                children: const [
                  Text('Item 1'),
                  Text('Item 2'),
                  Text('Item 3'),
                ],
              ),
            ),

            const Divider(),

            const Text('Kasus C - Keyboard Overflow'),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Masukkan komentar',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DetailPage(),
                  ),
                );
              },
              child: const Text('Buka Detail'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(
        child: Text(
          '$nim\n$nama\nDetail Page',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}