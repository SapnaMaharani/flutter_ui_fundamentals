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

  void toggleFavorite(String courseCode) {
    if (favorites.contains(courseCode)) {
      favorites.remove(courseCode);
    } else {
      favorites.add(courseCode);
    }
    notifyListeners();
  }
}