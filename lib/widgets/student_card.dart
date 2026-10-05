import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String nim;
  final String nama;

  const StudentCard({
    super.key,
    required this.nim,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '$nim - $nama',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}