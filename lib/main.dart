import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart'; // Memanggil model yang baru dibuat

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

  void toggleFavorite(String courseCode) {
    if (favorites.contains(courseCode)) {
      favorites.remove(courseCode);
    } else {
      favorites.add(courseCode);
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
      home: Tahap8Screen(),
    );
  }
}

class Tahap8Screen extends StatelessWidget {
  const Tahap8Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Simulasi data mentah JSON
    final Map<String, dynamic> jsonCourse = {
      'code': 'M001',
      'title': 'Pemrograman Mobile',
      'credits': 3,
      'status': 'Wajib'
    };

    // 2. Mengubah JSON mentah menjadi Object Course menggunakan fromJson
    final Course course = Course.fromJson(jsonCourse);

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8: Membuat Model')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          Consumer<CourseProvider>(
            builder: (context, provider, child) {
              // Mengecek status favorite menggunakan properti dari object course
              final isFav = provider.favorites.contains(course.code);
              
              return ListTile(
                // Menampilkan data menggunakan properti dari object course
                title: Text(course.title),
                subtitle: Text('${course.credits} SKS - ${course.status}'),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    context.read<CourseProvider>().toggleFavorite(course.code);
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