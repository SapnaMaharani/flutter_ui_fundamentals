import 'package:flutter/material.dart';

const nim = '2415051024';
const nama = 'Ni Putu Sapna Maharani';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ),
);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12'),
      ),

      body: Center(
        child: InkWell(

          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course dipilih'),
              ),
            );
          },

          onLongPress: () {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('Info Course'),
                content: Text('Flutter UI Fundamentals'),
              ),
            );
          },

          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    '$nim\n$nama',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Flutter UI Fundamentals',
                    style: TextStyle(fontSize: 18),
                  ),

                  IconButton(
                    icon: Icon(
                      favorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),

                    onPressed: () {
                      setState(() {
                        favorite = !favorite;
                      });
                    },
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