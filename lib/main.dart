import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<List<dynamic>> loadData() async {
    final data = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    return jsonDecode(data);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tahap 6'),
        ),
        body: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final students = snapshot.data!;

            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      '${students[index]['nim']}',
                    ),
                    subtitle: Text(
                      '${students[index]['nama']}',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}