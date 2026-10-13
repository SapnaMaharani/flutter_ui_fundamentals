import 'package:flutter/material.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Tahap5ChangeNotifier()));

// 1. Buat Class ChangeNotifier (Sebagai State Object)
class CourseProvider extends ChangeNotifier {
  // Collection untuk menyimpan daftar course yang di-favorite
  final Set<String> favorites = {};

  // Method untuk menambah/menghapus favorite
  void toggleFavorite(String course) {
    if (favorites.contains(course)) {
      favorites.remove(course);
    } else {
      favorites.add(course);
    }
    // Wajib dipanggil agar widget yang mendengarkan (listener) tahu ada perubahan
    notifyListeners(); 
  }
}

// 2. Tampilan UI
class Tahap5ChangeNotifier extends StatefulWidget {
  const Tahap5ChangeNotifier({super.key});

  @override
  State<Tahap5ChangeNotifier> createState() => _Tahap5ChangeNotifierState();
}

class _Tahap5ChangeNotifierState extends State<Tahap5ChangeNotifier> {
  // Inisialisasi object CourseProvider
  final CourseProvider courseProvider = CourseProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5: ChangeNotifier')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          
          // Mendengarkan perubahan dari CourseProvider
          ListenableBuilder(
            listenable: courseProvider,
            builder: (context, child) {
              final isFav = courseProvider.favorites.contains('Pemrograman Mobile');
              
              return ListTile(
                title: const Text('Pemrograman Mobile'),
                subtitle: Text('Total Favorite: ${courseProvider.favorites.length}'),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    // Memanggil method perubahan state
                    courseProvider.toggleFavorite('Pemrograman Mobile');
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}