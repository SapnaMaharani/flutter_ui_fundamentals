import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 12: Refactor Folder')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(
                    child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)),
                  );
                }
                if (provider.courses.isEmpty) {
                  return const Center(child: Text('Tidak ada data kursus.'));
                }
                return ListView.builder(
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    final isFav = provider.favorites.contains(course.code);

                    return ListTile(
                      title: Text(course.title),
                      subtitle: Text('${course.credits} SKS - ${course.status}'),
                      trailing: IconButton(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                        onPressed: () {
                          context.read<CourseProvider>().toggleFavorite(course.code);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}