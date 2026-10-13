import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    // Membaca file JSON dari asset
    final jsonString = await rootBundle.loadString('assets/data/student_data.json');
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;
    
    // Mengubah data Map menjadi List<Course>
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}