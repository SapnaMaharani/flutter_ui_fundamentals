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
          title: const Text('Tahap 4'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Text('$studentId - $studentName'),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 80,
                      color: Colors.blue.shade200,
                      child: const Center(
                        child: Text('Panel A'),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Container(
                      height: 80,
                      color: Colors.green.shade200,
                      child: const Center(
                        child: Text('Panel B'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Flutter')),
                  Chip(label: Text('Dart')),
                  Chip(label: Text('UI')),
                  Chip(label: Text('Layout')),
                  Chip(label: Text('Git')),
                  Chip(label: Text('Mobile')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}