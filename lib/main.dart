import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/course.dart'; 

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://grrelxipjcpmaxnkqnfd.supabase.co',
    anonKey: 'sb_publishable__J_ypG1Z4qHJyu-PsVUjhg_5IFn5bJF',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider()..loadCourses(),
      child: const MaterialApp(home: Tahap11Screen(), debugShowCheckedModeBanner: false),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true; 
    error = null; 
    notifyListeners();
    
    try {
      final supabase = Supabase.instance.client;
      // Membaca data langsung dari tabel courses
      final response = await supabase.from('courses').select();
      
      courses = (response as List<dynamic>)
          .map((json) => Course(
                id: json['id'],
                code: json['code'],
                title: json['title'],
                credits: json['credits'],
                status: json['status'],
              ))
          .toList();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false; 
      notifyListeners();
    }
  }
}

class Tahap11Screen extends StatelessWidget {
  const Tahap11Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Judul AppBar sudah diubah menjadi Tahap 11
      appBar: AppBar(title: const Text('Tahap 11: Database Supabase')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16), 
            child: Text('$studentId • $studentName', style: TextStyle(fontWeight: FontWeight.bold))
          ),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (ctx, prov, _) {
                if (prov.isLoading) return const Center(child: CircularProgressIndicator());
                if (prov.error != null) return Center(child: Text('Error: ${prov.error}', style: const TextStyle(color: Colors.red)));
                if (prov.courses.isEmpty) return const Center(child: Text('Tidak ada data di tabel Supabase'));
                
                return ListView.builder(
                  itemCount: prov.courses.length,
                  itemBuilder: (context, index) {
                    final course = prov.courses[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(course.code.substring(0, 1))),
                      title: Text(course.title),
                      subtitle: Text('${course.code} • ${course.credits} SKS • ${course.status}'),
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