class Notification {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String status;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Notification fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdBy: map['createdBy'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
