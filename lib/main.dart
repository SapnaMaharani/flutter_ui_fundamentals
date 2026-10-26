import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/responsive_shell.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://grrelxipjcpmaxnkqnfd.supabase.co',
    anonKey: 'sb_publishable__J_ypG1Z4qHJyu-PsVUjhg_5IFn5bJF',
  );

  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const CourseDataManagerApp(),
    ),
  );
}

class CourseDataManagerApp extends StatelessWidget {
  const CourseDataManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Data Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(),
    );
  }
}