import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart'; // Import repository baru

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
      home: Tahap10Screen(),
    );
  }
}

class Tahap10Screen extends StatelessWidget {
  const Tahap10Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 10: Repository Pattern')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Menguji pemanggilan melalui Repository
                final service = CourseService();
                final repository = CourseRepository(service);
                final courses = await repository.getCourses();
                
                debugPrint('Berhasil memuat ${courses.length} kursus melalui Repository!');
                for (var c in courses) {
                  debugPrint('- [${c.code}] ${c.title} (${c.credits} SKS)');
                }
              },
              child: const Text('Test Repository Data'),
            ),
          ],
        ),
      ),
    );
  }
}