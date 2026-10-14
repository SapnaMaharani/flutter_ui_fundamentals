import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kursus')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(course.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('${course.credits} SKS - ${course.status}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final isFav = provider.isFavorite(course.code);
                return ElevatedButton.icon(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  label: Text(isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                  onPressed: () => provider.toggleFavorite(course.code),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}