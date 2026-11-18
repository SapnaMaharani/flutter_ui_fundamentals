import '../models/course.dart';
import '../services/course_supabase_service.dart';

class CourseRepository {
  final CourseSupabaseService dataSource;

  CourseRepository({CourseSupabaseService? dataSource})
      : dataSource = dataSource ?? CourseSupabaseService();

  // Mengambil daftar course dari Supabase.
  Future<List<Course>> getCourses() {
    return dataSource.getCourses();
  }

  // Menambahkan course ke Supabase.
  // owner_id otomatis diisi oleh CourseSupabaseService.
  Future<Course> createCourse(Course course) {
    return dataSource.createCourse(course);
  }

  // Memperbarui course sesuai aturan RLS.
  Future<void> updateCourse(int id, Course course) {
    return dataSource.updateCourse(id, course);
  }

  // Menghapus course sesuai aturan RLS.
  Future<void> deleteCourse(int id) {
    return dataSource.deleteCourse(id);
  }
}
