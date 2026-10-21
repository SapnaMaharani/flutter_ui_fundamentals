class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  // factory untuk mengubah data JSON menjadi Object Course
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      // Jika API tidak punya 'code', kita buat otomatis dari ID-nya
      code: json['code'] as String? ?? 'MOB-${json['id'] ?? 0}', 
      title: json['title'] as String? ?? 'No Title',
      // Jika API tidak punya 'credits', beri nilai bawaan 3
      credits: json['credits'] as int? ?? 3, 
      // Jika API tidak punya 'status', beri nilai bawaan 'planned'
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  // method untuk mengubah Object Course kembali menjadi JSON (biasanya dipakai untuk POST/PUT)
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}