class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({this.id, required this.code, required this.title, required this.credits, this.status = 'planned'});

  // factory dari JSON ke Object
  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as int?,
    code: json['code'] as String,
    title: json['title'] as String,
    credits: json['credits'] as int,
    status: json['status'] as String? ?? 'planned',
  );

  // method dari Object ke JSON
  Map<String, dynamic> toJson() => {'code': code, 'title': title, 'credits': credits, 'status': status};
}