class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}