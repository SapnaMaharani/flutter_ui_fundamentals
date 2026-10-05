import 'package:flutter/material.dart';

const nim = '2415051024';
const nama = 'Ni Putu Sapna Maharani';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: Shell(),
));

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int index = 0;

  final pages = const [
    Text('Home\n$nim\n$nama', textAlign: TextAlign.center),
    Text('Courses\nFlutter UI Fundamentals'),
    Text('Profile\n$nim\n$nama', textAlign: TextAlign.center),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        return Scaffold(
          body: c.maxWidth < 840
              ? pages[index]
              : Row(
                  children: [
                    navRail(),
                    Expanded(child: pages[index]),
                  ],
                ),

          bottomNavigationBar: c.maxWidth < 840
              ? NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: (i) =>
                      setState(() => index = i),
                  destinations: navBar(),
                )
              : null,
        );
      },
    );
  }

  NavigationRail navRail() => NavigationRail(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            setState(() => index = i),
        destinations: const [
          NavigationRailDestination(
              icon: Icon(Icons.home), label: Text('Home')),
          NavigationRailDestination(
              icon: Icon(Icons.book), label: Text('Courses')),
          NavigationRailDestination(
              icon: Icon(Icons.person), label: Text('Profile')),
        ],
      );

  List<NavigationDestination> navBar() => const [
        NavigationDestination(
            icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.book), label: 'Courses'),
        NavigationDestination(
            icon: Icon(Icons.person), label: 'Profile'),
      ];
}