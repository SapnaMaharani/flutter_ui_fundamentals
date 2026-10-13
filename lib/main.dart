import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_service.dart'; // Memanggil service yang baru dibuat

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
      home: Tahap9Screen(),
    );
  }
}

class Tahap9Screen extends StatelessWidget {
  const Tahap9Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9: Service / Data Source')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // NAMA DAN NIM AKAN TAMPIL DI LAYAR LEWAT WIDGET INI
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Menguji pemanggilan CourseService
                final service = CourseService();
                final courses = await service.loadCourses();
                
                // Menampilkan hasil uji ke Debug Console (Terminal VS Code)
                debugPrint('Berhasil memuat ${courses.length} kursus dari JSON Asset!');
                for (var c in courses) {
                  debugPrint('- ${c.code}: ${c.title}');
                }
              },
              child: const Text('Test Load JSON Data'),
            ),
          ],
        ),
      ),
    );
  }
}