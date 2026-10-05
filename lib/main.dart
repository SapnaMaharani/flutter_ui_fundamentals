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
          title: const Text('Tahap 8'),
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Image.asset(
                    'assets/images/profile.png',
                    width: 120,
                    height: 120,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    studentId,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  Text(
                    studentName,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}