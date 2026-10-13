import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class CourseProvider extends ChangeNotifier {
  final Set<String> favorites = {};

  void toggleFavorite(String course) {
    if (favorites.contains(course)) {
      favorites.remove(course);
    } else {
      favorites.add(course);
    }
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap6ProviderSetup(),
    );
  }
}

class Tahap6ProviderSetup extends StatelessWidget {
  const Tahap6ProviderSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6: Provider Setup')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Consumer<CourseProvider>(
            builder: (context, provider, child) {
              final isFav = provider.favorites.contains('Pemrograman Mobile');
              return ListTile(
                title: const Text('Pemrograman Mobile'),
                subtitle: Text('Total Favorite: ${provider.favorites.length}'),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    provider.toggleFavorite('Pemrograman Mobile');
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