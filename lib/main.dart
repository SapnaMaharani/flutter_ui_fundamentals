import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/course.dart';
import 'services/course_supabase_service.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://grrelxipjcpmaxnkqnfd.supabase.co',
    anonKey: 'sb_publishable__J_ypG1Z4qHJyu-PsVUjhg_5IFn5bJF',
  );

  final supabaseService = CourseSupabaseService();

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(supabaseService)..loadCourses(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Tahap12Screen(),
      ),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  final CourseSupabaseService service;
  CourseProvider(this.service);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await service.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class Tahap12Screen extends StatelessWidget {
  const Tahap12Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12: SELECT Supabase'),
      ),
      body: Column(
        children: [
          // Menampilkan Nama dan NIM Mahasiswa
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: const Text(
              '$studentId • $studentName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (ctx, prov, _) {
                if (prov.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (prov.error != null) {
                  return Center(
                    child: Text('Error: ${prov.error}', style: const TextStyle(color: Colors.red)),
                  );
                }
                if (prov.courses.isEmpty) {
                  return const Center(child: Text('Tidak ada data di tabel Supabase'));
                }

                return ListView.builder(
                  itemCount: prov.courses.length,
                  itemBuilder: (context, index) {
                    final course = prov.courses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(course.code.isNotEmpty ? course.code[0] : '?'),
                        ),
                        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<CourseProvider>().loadCourses(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}