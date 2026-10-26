import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';

const String studentName = 'Ni Putu Sapna Maharani';
const String studentId = '2415051024';

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _currentIndex = 0;

  void _showCourseDialog(BuildContext context, {Course? course}) {
    final formKey = GlobalKey<FormState>();
    final codeCtrl = TextEditingController(text: course?.code ?? '');
    final titleCtrl = TextEditingController(text: course?.title ?? '');
    final creditsCtrl = TextEditingController(text: course?.credits.toString() ?? '');
    String selectedStatus = course?.status ?? 'active';
    final isEditing = course != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(isEditing ? 'Edit Course' : 'Create Course'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeCtrl,
                    decoration: const InputDecoration(labelText: 'Kode Course'),
                    enabled: !isEditing,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Judul Course'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: creditsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'SKS'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                      if (int.tryParse(v) == null) return 'Harus angka';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: ['planned', 'active', 'done'].contains(selectedStatus)
                        ? selectedStatus
                        : 'active',
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: const [
                      DropdownMenuItem(value: 'planned', child: Text('planned')),
                      DropdownMenuItem(value: 'active', child: Text('active')),
                      DropdownMenuItem(value: 'done', child: Text('done')),
                    ],
                    onChanged: (v) {
                      if (v != null) setStateDialog(() => selectedStatus = v);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final prov = context.read<CourseProvider>();
                  Navigator.pop(ctx);
                  if (isEditing) {
                    final updated = Course(
                      id: course.id,
                      code: course.code,
                      title: titleCtrl.text.trim(),
                      credits: int.parse(creditsCtrl.text.trim()),
                      status: selectedStatus,
                    );
                    final ok = await prov.editCourse(course.id!, updated);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok ? 'Berhasil mengubah course' : 'Gagal mengubah course'),
                          backgroundColor: ok ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  } else {
                    final newCourse = Course(
                      code: codeCtrl.text.trim(),
                      title: titleCtrl.text.trim(),
                      credits: int.parse(creditsCtrl.text.trim()),
                      status: selectedStatus,
                    );
                    final ok = await prov.addCourse(newCourse);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ok ? 'Berhasil menambah course' : 'Gagal menambah course'),
                          backgroundColor: ok ? Colors.green : Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(isEditing ? 'Simpan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus mata kuliah "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              if (course.id != null) {
                final ok = await context.read<CourseProvider>().removeCourse(course.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok ? 'Course berhasil dihapus' : 'Gagal menghapus course'),
                      backgroundColor: ok ? Colors.green : Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildListTab(CourseProvider prov) {
    if (prov.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (prov.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 12),
              Text(
                'Terjadi Kesalahan:\n${prov.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => prov.loadCourses(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi (Retry)'),
              ),
            ],
          ),
        ),
      );
    }

    if (prov.courses.isEmpty) {
      return const Center(child: Text('Tidak ada data courses di Supabase.'));
    }

    return ListView.builder(
      itemCount: prov.courses.length,
      itemBuilder: (context, index) {
        final item = prov.courses[index];
        final isFav = prov.isFavorite(item.code);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CourseDetailPage(course: item)),
              );
            },
            leading: CircleAvatar(
              child: Text(item.code.isNotEmpty ? item.code[0] : '?'),
            ),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.code} • ${item.credits} SKS • ${item.status}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () => prov.toggleFavorite(item.code),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showCourseDialog(context, course: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(context, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesTab(CourseProvider prov) {
    final favs = prov.favoriteCourses;
    if (favs.isEmpty) {
      return const Center(child: Text('Belum ada course favorit.'));
    }

    return ListView.builder(
      itemCount: favs.length,
      itemBuilder: (context, index) {
        final item = favs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CourseDetailPage(course: item)),
              );
            },
            leading: CircleAvatar(
              child: Text(item.code.isNotEmpty ? item.code[0] : '?'),
            ),
            title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item.code} • ${item.credits} SKS • ${item.status}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => prov.toggleFavorite(item.code),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CourseProvider>();
    final isWide = MediaQuery.of(context).size.width >= 600;

    final content = Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: const Text(
            '$studentId • $studentName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        Expanded(
          child: _currentIndex == 0 ? _buildListTab(prov) : _buildFavoritesTab(prov),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Course Data Manager' : 'Favorites'),
      ),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.list), label: Text('Courses')),
                    NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: content),
              ],
            )
          : content,
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.list), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
              ],
            ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showCourseDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}