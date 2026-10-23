import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/course.dart'; // Import model

void main() => runApp(const MaterialApp(home: Tahap3Screen(), debugShowCheckedModeBanner: false));

class Tahap3Screen extends StatefulWidget { const Tahap3Screen({super.key}); @override State<Tahap3Screen> createState() => _Tahap3State(); }

class _Tahap3State extends State<Tahap3Screen> {
  List<Course> _courses = [];
  bool _loading = false;
  // Ganti URL ke API dosen
  final String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  Future<void> _fetch() async {
    setState(() => _loading = true);
    final res = await http.get(Uri.parse(apiUrl));
    if (res.statusCode == 200) {
      setState(() {
        _courses = (jsonDecode(res.body) as List).map((e) => Course.fromJson(e)).toList();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Model Dart')),
      body: Column(children: [
        const Padding(padding: EdgeInsets.all(16), child: Text('2415051024 • Ni Putu Sapna Maharani', style: TextStyle(fontWeight: FontWeight.bold))),
        ElevatedButton(onPressed: _fetch, child: const Text('Load JSON to Model')),
        Expanded(child: _loading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: _courses.length,
          itemBuilder: (ctx, i) => ListTile(
            leading: CircleAvatar(child: Text(_courses[i].id.toString())),
            title: Text(_courses[i].title, maxLines: 1), 
            subtitle: Text('${_courses[i].code} • ${_courses[i].credits} SKS • Status: ${_courses[i].status}')
          ),
        ))
      ]),
    );
  }
}