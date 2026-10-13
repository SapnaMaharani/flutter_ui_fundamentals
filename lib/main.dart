import 'package:flutter/material.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Tahap2Parent()));

// PARENT WIDGET: Pemilik State
class Tahap2Parent extends StatefulWidget {
  const Tahap2Parent({super.key});
  @override
  State<Tahap2Parent> createState() => _Tahap2ParentState();
}

class _Tahap2ParentState extends State<Tahap2Parent> {
  // Shared State yang dimiliki oleh Parent
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          // Melempar state ke Child 1 (CourseSummary)
          CourseSummary(isFavorite: isFavorite),
          
          // Melempar state DAN callback ke Child 2 (CourseList) -> Inilah Prop Drilling
          CourseList(
            isFavorite: isFavorite,
            onFavoriteToggled: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
    );
  }
}

// CHILD 1: Hanya Menerima Data
class CourseSummary extends StatelessWidget {
  final bool isFavorite;
  const CourseSummary({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total Favorite: ${isFavorite ? 1 : 0}', 
        style: const TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );
  }
}

// CHILD 2: Menerima Data dan Callback
class CourseList extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteToggled;

  const CourseList({super.key, required this.isFavorite, required this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Pemrograman Mobile'),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
        onPressed: onFavoriteToggled, // Memanggil fungsi milik Parent
      ),
    );
  }
}