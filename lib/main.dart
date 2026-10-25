import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/course.dart';
import 'services/course_data_source.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'widgets/error_view.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://grrelxipjcpmaxnkqnfd.supabase.co',
    anonKey: 'sb_publishable__J_ypG1Z4qHJyu-PsVUjhg_5IFn5bJF',
  );

  final CourseDataSource dataSource = CourseApiService('https://course-api-pearl.vercel.app');
  final repository = CourseRepository(dataSource);
  
  runApp(ChangeNotifierProvider(
    create: (_) => CourseProvider(repository)..loadCourses(),
    child: const MaterialApp(home: Tahap10Screen(), debugShowCheckedModeBanner: false),
  ));
}

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.repository);
  final CourseRepository repository;
  
  List<Course> courses = [];
  bool isLoading = false, isSaving = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true; error = null; notifyListeners();
    try { courses = await repository.getCourses(); } catch (e) { error = e.toString(); }
    finally { isLoading = false; notifyListeners(); }
  }

  Future<bool> addCourse(Course course) async {
    isSaving = true; notifyListeners();
    try { await repository.createCourse(course); await loadCourses(); return true; } 
    catch (e) { error = e.toString(); return false; } finally { isSaving = false; notifyListeners(); }
  }

  Future<bool> editCourse(int id, Course course) async {
    isSaving = true; notifyListeners();
    try { await repository.updateCourse(id, course); await loadCourses(); return true; } 
    catch (e) { error = e.toString(); return false; } finally { isSaving = false; notifyListeners(); }
  }

  Future<bool> deleteCourse(int id) async {
    isSaving = true; notifyListeners();
    try { await repository.deleteCourse(id); await loadCourses(); return true; } 
    catch (e) { error = e.toString(); return false; } finally { isSaving = false; notifyListeners(); }
  }
}

class Tahap10Screen extends StatelessWidget {
  const Tahap10Screen({super.key});

  void _showForm(BuildContext context, {Course? existingCourse}) {
    final key = GlobalKey<FormState>();
    final cCode = TextEditingController(text: existingCourse?.code ?? '');
    final cTitle = TextEditingController(text: existingCourse?.title ?? '');
    final cCred = TextEditingController(text: existingCourse?.credits.toString() ?? '');
    String status = existingCourse?.status ?? 'planned';
    final isEdit = existingCourse != null;

    showDialog(context: context, barrierDismissible: false, builder: (dCtx) => AlertDialog(
        title: Text(isEdit ? 'Edit Course' : 'Tambah Course'),
        content: Form(key: key, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: cCode, readOnly: isEdit, decoration: InputDecoration(labelText: 'Kode', filled: isEdit, fillColor: Colors.grey[200]), validator: (v) => v!.isEmpty ? 'Wajib' : null),
          TextFormField(controller: cTitle, decoration: const InputDecoration(labelText: 'Judul'), validator: (v) => v!.isEmpty ? 'Wajib' : null),
          TextFormField(controller: cCred, decoration: const InputDecoration(labelText: 'SKS'), keyboardType: TextInputType.number, validator: (v) => int.tryParse(v ?? '') == null ? 'Angka' : null),
          DropdownButtonFormField<String>(value: status, items: ['planned', 'active', 'done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => status = v!),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Batal')),
          Consumer<CourseProvider>(builder: (ctx, prov, _) => ElevatedButton(
              onPressed: prov.isSaving ? null : () async {
                if (key.currentState!.validate()) {
                  final course = Course(code: cCode.text, title: cTitle.text, credits: int.parse(cCred.text), status: status);
                  final ok = isEdit ? await prov.editCourse(existingCourse.id!, course) : await prov.addCourse(course);
                  if (!dCtx.mounted) return; Navigator.pop(dCtx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Berhasil!' : 'Gagal!'), backgroundColor: ok ? Colors.green : Colors.red));
                }
              },
              child: prov.isSaving ? const SizedBox(width:16, height:16, child: CircularProgressIndicator()) : const Text('Simpan'),
            ))
        ]));
  }

  void _confirmDel(BuildContext context, CourseProvider prov, Course course) {
    showDialog(context: context, builder: (dCtx) => AlertDialog(
        title: const Text('Hapus'), content: Text('Hapus ${course.title}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Batal')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dCtx); final ok = await prov.deleteCourse(course.id!);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Berhasil dihapus!' : 'Gagal!'), backgroundColor: ok ? Colors.green : Colors.red));
            }, child: const Text('Hapus', style: TextStyle(color: Colors.white)))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 10: Backend Supabase')),
      body: Column(children: [
          const Padding(padding: EdgeInsets.all(16), child: Text('$studentId • $studentName', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Consumer<CourseProvider>(builder: (ctx, prov, _) {
              if (prov.isLoading && prov.courses.isEmpty) return const Center(child: CircularProgressIndicator());
              if (prov.error != null && prov.courses.isEmpty) return ErrorView(message: prov.error!, onRetry: prov.loadCourses);
              if (prov.courses.isEmpty) return const Center(child: Text('Data belum tersedia'));
              return ListView.builder(itemCount: prov.courses.length, itemBuilder: (c, i) => ListTile(
                title: Text(prov.courses[i].title), subtitle: Text('${prov.courses[i].code} • ${prov.courses[i].credits} SKS'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, existingCourse: prov.courses[i])),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _confirmDel(context, prov, prov.courses[i])),
                  ]),
              ));
            }))
        ]),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(context), child: const Icon(Icons.add)),
    );
  }
}