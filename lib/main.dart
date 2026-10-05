import 'package:flutter/material.dart';

const String studentId = '2415051024';
const String studentName = 'Ni Putu Sapna Maharani';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 3'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return buildLayout(
                'Compact',
                Colors.blue.shade100,
              );
            } else if (constraints.maxWidth < 840) {
              return buildLayout(
                'Medium',
                Colors.green.shade100,
              );
            } else {
              return buildLayout(
                'Expanded',
                Colors.orange.shade100,
              );
            }
          },
        ),
      ),
    );
  }
}

Widget buildLayout(String type, Color color) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(20),
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text('$studentId - $studentName'),
        ],
      ),
    ),
  );
}