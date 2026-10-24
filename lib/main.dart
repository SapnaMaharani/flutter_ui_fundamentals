import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_service.dart'; // Sesuai nama file kamu
import 'widgets/error_view.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() {
  final apiService = CourseApiService('https://course-api-pearl.vercel.app');

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(apiService)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.apiService);
  final CourseApiService apiService;

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await apiService.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap5Screen(),
    );
  }
}

class Tahap5Screen extends StatelessWidget {
  const Tahap5Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5: Async States')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.error != null) {
                  return ErrorView(
                    message: provider.error!,
                    onRetry: provider.loadCourses,
                  );
                }
                
                if (provider.courses.isEmpty) {
                  return const Center(child: Text('Data course belum tersedia'));
                }

                return ListView.builder(
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    return ListTile(
                      title: Text(course.title, maxLines: 1),
                      subtitle: Text('${course.code} • ${course.credits} SKS • Status: ${course.status}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}