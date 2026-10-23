import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tahap2Screen(),
    );
  }
}

class Tahap2Screen extends StatefulWidget {
  const Tahap2Screen({super.key});

  @override
  State<Tahap2Screen> createState() => _Tahap2ScreenState();
}

class _Tahap2ScreenState extends State<Tahap2Screen> {
  // URL resmi dari dosen
  final String apiUrl = 'https://course-api-pearl.vercel.app/courses';
  String _resultText = 'Tekan tombol untuk mengambil data';

  Future<void> _fetchCourses() async {
    setState(() {
      _resultText = 'Loading...';
    });
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _resultText = 'Berhasil mengambil ${data.length} data kursus (Status 200 OK)!';
        });
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _resultText = 'Terjadi kesalahan:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2: HTTP GET')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Text(
                _resultText, 
                textAlign: TextAlign.center, 
                style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchCourses,
                child: const Text('Ambil Data (HTTP GET)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}