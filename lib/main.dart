import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  final Set<String> favorites = {};

  void toggleFavorite(String course) {
    if (favorites.contains(course)) {
      favorites.remove(course);
    } else {
      favorites.add(course);
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap7Screen(),
    );
  }
}

class Tahap7Screen extends StatelessWidget {
  const Tahap7Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Menggunakan watch() untuk menampilkan jumlah favorite
    final providerWatch = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7: watch, read, Consumer')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Favorite (via watch): ${providerWatch.favorites.length}', 
              style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),

          // 3. Menggunakan Consumer pada satu area kecil (ListTile)
          Consumer<CourseProvider>(
            builder: (context, provider, child) {
              final isFav = provider.favorites.contains('Pemrograman Mobile');
              return ListTile(
                title: const Text('Pemrograman Mobile'),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    // 2. Menggunakan read() pada aksi (onPressed)
                    context.read<CourseProvider>().toggleFavorite('Pemrograman Mobile');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}