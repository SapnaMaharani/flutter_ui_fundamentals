import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/course.dart'; 

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap3Screen(),
    );
  }
}

class Tahap3Screen extends StatefulWidget {
  const Tahap3Screen({super.key});

  @override
  State<Tahap3Screen> createState() => _Tahap3ScreenState();
}

class _Tahap3ScreenState extends State<Tahap3Screen> {
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';
  // State untuk menyimpan List dari Object Course
  List<Course> _courses = [];
  bool _isLoading = false;

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        setState(() {
          // Tahap 3: Konversi response JSON (List<dynamic>) menjadi List<Course>
          _courses = data.map((json) => Course.fromJson(json as Map<String, dynamic>)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Model Dart')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: _fetchCourses,
            child: const Text('Load JSON to Model'),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      // Menampilkan data dari Object Course
                      return ListTile(
                        leading: CircleAvatar(child: Text(course.id.toString())),
                        title: Text(course.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${course.code} • ${course.credits} SKS • Status: ${course.status}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}