import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kursus Favorit')),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          final favs = provider.favoriteCourses;
          
          if (favs.isEmpty) {
            return const Center(child: Text('Belum ada kursus favorit.'));
          }
          
          return ListView.builder(
            itemCount: favs.length,
            itemBuilder: (context, index) {
              final course = favs[index];
              return ListTile(
                title: Text(course.title),
                subtitle: Text('${course.credits} SKS'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () => provider.toggleFavorite(course.code),
                ),
              );
            },
          );
        },
      ),
    );
  }
}