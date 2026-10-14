import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  
  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;
  final Set<String> favorites = {};

  // Fungsi mengecek status favorit
  bool isFavorite(String code) => favorites.contains(code);

  // Getter untuk mengambil data kursus yang difavoritkan
  List<Course> get favoriteCourses {
    return courses.where((c) => favorites.contains(c.code)).toList();
  }

  void toggleFavorite(String code) {
    favorites.contains(code) ? favorites.remove(code) : favorites.add(code);
    notifyListeners();
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}