
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final SupabaseClient supabase = Supabase.instance.client;

  // Mengambil semua course yang boleh dilihat pengguna.
  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map(
          (e) => Course.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // Menambahkan course dengan owner_id pengguna yang login.
  @override
  Future<Course> createCourse(Course course) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final row = await supabase
        .from('courses')
        .insert({
          'code': course.code,
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
          'owner_id': user.id,
        })
        .select()
        .single();

    return Course.fromJson(row);
  }

  // Mengubah course sesuai izin RLS.
  @override
  Future<void> updateCourse(int id, Course course) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final result = await supabase
        .from('courses')
        .update({
          'code': course.code,
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
        })
        .eq('id', id)
        .select('id');

    if (result.isEmpty) {
      throw Exception(
        'Update ditolak: course tidak ditemukan '
        'atau kamu tidak memiliki izin.',
      );
    }
  }

  // Menghapus course sesuai izin RLS.
  @override
  Future<void> deleteCourse(int id) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final result = await supabase
        .from('courses')
        .delete()
        .eq('id', id)
        .select('id');

    if (result.isEmpty) {
      throw Exception(
        'Delete ditolak: course tidak ditemukan '
        'atau kamu tidak memiliki izin.',
      );
    }
  }
}
