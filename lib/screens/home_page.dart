import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    
    final List<Widget> pages = [
      _buildDashboard(provider),
      _buildCourseList(provider),
      _buildFavorites(provider),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        title: const Text('Course Explorer v2', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
        elevation: 0,
        backgroundColor: const Color(0xFF1976D2),
        centerTitle: false,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xFFE3F2FD), 
          selectedItemColor: const Color(0xFF0D47A1), 
          unselectedItemColor: const Color(0xFF0D47A1).withOpacity(0.5),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          ],
        ),
      ),
    );
  }

  // --- TAMPILAN TAB 1: DASHBOARD ---
  Widget _buildDashboard(CourseProvider provider) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFFF1F8E9), borderRadius: BorderRadius.circular(8)),
          child: const Text('$studentId • $studentName', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1))),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _statCard('Courses', provider.courses.length.toString())),
            const SizedBox(width: 16),
            Expanded(child: _statCard('Favorites', provider.favorites.length.toString())),
          ],
        ),
        const SizedBox(height: 24),
        _statusCard('Git & GitHub', 'done', const Color(0xFF00897B)),
        _statusCard('Dart Fundamentals', 'done', const Color(0xFF00897B)),
        _statusCard('State Management', 'active', const Color(0xFF00897B)),
      ],
    );
  }

  Widget _statCard(String title, String count) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE), 
        border: Border.all(color: const Color(0xFFB3E5FC), width: 1.5), 
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF455A64), fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF0D47A1))),
        ],
      ),
    );
  }

  Widget _statusCard(String title, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCFD8DC), width: 1.5), 
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1C2833))),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 14)),
        ),
      ),
    );
  }

  // --- TAMPILAN TAB 2: DAFTAR KURSUS ---
  Widget _buildCourseList(CourseProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)));
    if (provider.courses.isEmpty) return const Center(child: Text('Tidak ada data kursus.'));
    
    return ListView.builder(
      itemCount: provider.courses.length,
      itemBuilder: (context, index) {
        final course = provider.courses[index];
        final isFav = provider.isFavorite(course.code);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${course.credits} SKS - ${course.status}'),
            trailing: IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              onPressed: () => context.read<CourseProvider>().toggleFavorite(course.code),
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(course: course))),
          ),
        );
      },
    );
  }

  // --- TAMPILAN TAB 3: KURSUS FAVORIT ---
  Widget _buildFavorites(CourseProvider provider) {
    final favs = provider.favoriteCourses;
    if (favs.isEmpty) return const Center(child: Text('Belum ada kursus favorit.'));
    return ListView.builder(
      itemCount: favs.length,
      itemBuilder: (context, index) {
        final course = favs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${course.credits} SKS'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => provider.toggleFavorite(course.code),
            ),
          ),
        );
      },
    );
  }
}