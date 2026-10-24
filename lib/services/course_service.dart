import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';
import 'course_data_source.dart';

class CourseApiService implements CourseDataSource {
  CourseApiService(this.baseUrl);
  final String baseUrl;

  @override
  Future<List<Course>> getCourses() async {
    final res = await http.get(Uri.parse('$baseUrl/courses'));
    if (res.statusCode != 200) throw Exception('Gagal ambil course');
    return (jsonDecode(res.body) as List).map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final res = await http.post(Uri.parse('$baseUrl/courses'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(course.toJson()));
    if (res.statusCode == 200 || res.statusCode == 201) return Course.fromJson(jsonDecode(res.body));
    throw Exception('Gagal membuat course');
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    final res = await http.put(Uri.parse('$baseUrl/courses/$id'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(course.toJson()));
    if (res.statusCode < 200 || res.statusCode >= 300) throw Exception('Gagal memperbarui course');
  }

  @override
  Future<void> deleteCourse(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/courses/$id'));
    if (res.statusCode < 200 || res.statusCode >= 300) throw Exception('Gagal menghapus course');
  }
}