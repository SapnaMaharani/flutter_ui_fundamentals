import 'package:flutter/material.dart';

const nim = '2415051024';
const nama = 'Ni Putu Sapna Maharani';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FormPage(),
  ),
);

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  final key = GlobalKey<FormState>();

  final komentar = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: key,

          child: Column(
            children: [

              TextFormField(
                initialValue: nama,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                ),
              ),

              TextFormField(
                initialValue: nim,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                ),
              ),

              TextFormField(
                controller: komentar,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                ),

                validator: (v) {
                  if (v == null || v.length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text('Kirim'),

                onPressed: () {

                  if (key.currentState!.validate()) {

                    showDialog(
                      context: context,

                      builder: (_) => AlertDialog(
                        title: const Text('Feedback'),

                        content: Text(
                          komentar.text,
                        ),
                      ),
                    );

                  }

                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}