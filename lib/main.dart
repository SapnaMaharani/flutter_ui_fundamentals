import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/course.dart';
import 'services/course_supabase_service.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        home: Tahap13Screen(),
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

  Future<void> addCourse(Course course) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await service.createCourse(course);
      await loadCourses(); // Refresh daftar setelah insert
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}

class Tahap13Screen extends StatelessWidget {
  const Tahap13Screen({super.key});

  void _showAddCourseDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();
    final titleController = TextEditingController();
    final creditsController = TextEditingController();
    String selectedStatus = 'active';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Tambah Course Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: 'Kode Course (misal: C004)'),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Judul Course'),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: creditsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS / Credits'),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                      if (int.tryParse(val) == null) return 'Harus berupa angka';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'planned', child: Text('planned')),
                      DropdownMenuItem(value: 'active', child: Text('active')),
                      DropdownMenuItem(value: 'done', child: Text('done')),
                    ],
                    onChanged: (val) {
                      if (val != null) setStateDialog(() => selectedStatus = val);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newCourse = Course(
                    code: codeController.text.trim(),
                    title: titleController.text.trim(),
                    credits: int.parse(creditsController.text.trim()),
                    status: selectedStatus,
                  );
                  Navigator.pop(ctx);
                  await context.read<CourseProvider>().addCourse(newCourse);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13: INSERT Supabase'),
      ),
      body: Column(
        children: [
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
        onPressed: () => _showAddCourseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}