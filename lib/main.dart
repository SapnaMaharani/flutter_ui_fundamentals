import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_service.dart'; 

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MaterialApp(home: Tahap4Screen(), debugShowCheckedModeBanner: false));

class Tahap4Screen extends StatefulWidget { const Tahap4Screen({super.key}); @override State<Tahap4Screen> createState() => _Tahap4State(); }

class _Tahap4State extends State<Tahap4Screen> {
  final CourseApiService _apiService = CourseApiService('https://course-api-pearl.vercel.app');
  
  List<Course> _courses = [];
  bool _loading = false;

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final courses = await _apiService.getCourses();
      setState(() {
        _courses = courses;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4: Service Layer')),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.all(16), 
          child: Text('$studentId • $studentName', style: TextStyle(fontWeight: FontWeight.bold))
        ),
        ElevatedButton(onPressed: _fetch, child: const Text('Load Data via Service')),
        Expanded(
          child: _loading 
            ? const Center(child: CircularProgressIndicator()) 
            : ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(_courses[i].title, maxLines: 1), 
                  subtitle: Text('${_courses[i].code} • ${_courses[i].credits} SKS • Status: ${_courses[i].status}')
                ),
              )
        )
      ]),
    );
  }
}