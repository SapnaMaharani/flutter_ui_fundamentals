import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/course.dart';
import 'services/course_service.dart';
import 'widgets/error_view.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(ChangeNotifierProvider(
  create: (_) => CourseProvider(CourseApiService('https://course-api-pearl.vercel.app'))..loadCourses(),
  child: const MaterialApp(home: Tahap6Screen(), debugShowCheckedModeBanner: false),
));

class CourseProvider extends ChangeNotifier {
  CourseProvider(this.apiService);
  final CourseApiService apiService;
  List<Course> courses = [];
  bool isLoading = false, isSaving = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true; error = null; notifyListeners();
    try { courses = await apiService.getCourses(); }
    catch (e) { error = e.toString(); }
    finally { isLoading = false; notifyListeners(); }
  }

  Future<bool> addCourse(Course course) async {
    isSaving = true; notifyListeners();
    try {
      await apiService.createCourse(course);
      await loadCourses(); // Refresh list setelah berhasil
      return true;
    } catch (e) { error = e.toString(); return false; }
    finally { isSaving = false; notifyListeners(); }
  }
}

class Tahap6Screen extends StatelessWidget {
  const Tahap6Screen({super.key});

  void _showForm(BuildContext context) {
    final key = GlobalKey<FormState>();
    final cCode = TextEditingController(), cTitle = TextEditingController(), cCred = TextEditingController();
    String status = 'planned';

    showDialog(
      context: context, barrierDismissible: false,
      builder: (dCtx) => AlertDialog(
        title: const Text('Tambah Course Baru'),
        content: Form(key: key, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: cCode, decoration: const InputDecoration(labelText: 'Kode'), validator: (v) => v!.isEmpty ? 'Wajib' : null),
          TextFormField(controller: cTitle, decoration: const InputDecoration(labelText: 'Judul'), validator: (v) => v!.isEmpty ? 'Wajib' : null),
          TextFormField(controller: cCred, decoration: const InputDecoration(labelText: 'SKS'), keyboardType: TextInputType.number, validator: (v) => int.tryParse(v ?? '') == null ? 'Angka valid' : null),
          DropdownButtonFormField<String>(value: status, items: ['planned', 'active', 'done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => status = v!),
        ]))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('Batal')),
          Consumer<CourseProvider>(
            builder: (ctx, prov, _) => ElevatedButton(
              onPressed: prov.isSaving ? null : () async {
                if (key.currentState!.validate()) {
                  final ok = await prov.addCourse(Course(code: cCode.text, title: cTitle.text, credits: int.parse(cCred.text), status: status));
                  if (!dCtx.mounted) return;
                  Navigator.pop(dCtx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Berhasil!' : 'Gagal!'), backgroundColor: ok ? Colors.green : Colors.red));
                }
              },
              child: prov.isSaving ? const SizedBox(width:16, height:16, child: CircularProgressIndicator()) : const Text('Simpan'),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6: HTTP POST')),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16), child: Text('$studentId • $studentName', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Consumer<CourseProvider>(
            builder: (ctx, prov, _) {
              if (prov.isLoading && prov.courses.isEmpty) return const Center(child: CircularProgressIndicator());
              if (prov.error != null && prov.courses.isEmpty) return ErrorView(message: prov.error!, onRetry: prov.loadCourses);
              if (prov.courses.isEmpty) return const Center(child: Text('Data belum tersedia'));
              return ListView.builder(itemCount: prov.courses.length, itemBuilder: (c, i) => ListTile(
                title: Text(prov.courses[i].title), subtitle: Text('${prov.courses[i].code} • ${prov.courses[i].credits} SKS • Status: ${prov.courses[i].status}')
              ));
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showForm(context), child: const Icon(Icons.add)),
    );
  }
}