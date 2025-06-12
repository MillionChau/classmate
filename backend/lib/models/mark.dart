class Mark {
  final String id;
  final String studentId;
  final String classId;
  final String subject;
  final String teacherId;
  final double score;
  final DateTime createdAt;

  Mark({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.subject,
    required this.teacherId,
    required this.score,
    required this.createdAt,
  });

  factory Mark.fromJson(Map<String, dynamic> json) => Mark(
        id: json['id'],
        studentId: json['studentId'],
        classId: json['classId'],
        subject: json['subject'],
        teacherId: json['teacherId'],
        score: (json['score'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentId': studentId,
        'classId': classId,
        'subject': subject,
        'teacherId': teacherId,
        'score': score,
        'createdAt': createdAt.toIso8601String(),
      };
}
