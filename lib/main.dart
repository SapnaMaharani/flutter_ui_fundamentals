import 'package:flutter/material.dart';
import 'widgets/student_card.dart';

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
          title: const Text('Tahap 5'),
        ),
        body: Center(
          child: StudentCard(
            nim: studentId,
            nama: studentName,
          ),
        ),
      ),
    );
  }
}