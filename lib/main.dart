import 'package:flutter/material.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Tahap3LiftingState()));

// PARENT WIDGET: Pemilik State (Single Source of Truth)
class Tahap3LiftingState extends StatefulWidget {
  const Tahap3LiftingState({super.key});
  @override
  State<Tahap3LiftingState> createState() => _Tahap3LiftingStateState();
}

class _Tahap3LiftingStateState extends State<Tahap3LiftingState> {
  // State diangkat ke atas (Lifting State Up)
  List<String> favoriteCourses = [];

  // Fungsi untuk mengubah state (Akan dilempar ke child sebagai callback)
  void toggleFavorite(String course) {
    setState(() {
      if (favoriteCourses.contains(course)) {
        favoriteCourses.remove(course);
      } else {
        favoriteCourses.add(course);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3: Lifting State Up')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          // CHILD 1: Hanya menerima data jumlah (Membaca State)
          CourseSummary(favoriteCount: favoriteCourses.length),
          
          // CHILD 2 & 3: Menerima data dan fungsi (Membaca dan Mengubah State)
          CourseItem(
            courseName: 'Pemrograman Mobile',
            isFavorite: favoriteCourses.contains('Pemrograman Mobile'),
            onFavoriteToggled: () => toggleFavorite('Pemrograman Mobile'),
          ),
          CourseItem(
            courseName: 'Pemrograman Web',
            isFavorite: favoriteCourses.contains('Pemrograman Web'),
            onFavoriteToggled: () => toggleFavorite('Pemrograman Web'),
          ),
        ],
      ),
    );
  }
}

// WIDGET CHILD 1
class CourseSummary extends StatelessWidget {
  final int favoriteCount;
  const CourseSummary({super.key, required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('Total Favorite: $favoriteCount', 
        style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
    );
  }
}

// WIDGET CHILD 2 & 3
class CourseItem extends StatelessWidget {
  final String courseName;
  final bool isFavorite;
  final VoidCallback onFavoriteToggled;

  const CourseItem({super.key, required this.courseName, required this.isFavorite, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(courseName),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
        onPressed: onFavoriteToggled, // Memanggil fungsi milik Parent
      ),
    );
  }
}