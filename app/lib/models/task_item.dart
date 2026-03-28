class TaskItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final String status;
  final int points;
  final String? assignedToName;

  TaskItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.points,
    required this.assignedToName,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final assigned = json['assignedTo'];
    return TaskItem(
      id: json['_id'].toString(),
      type: json['type'] as String,
      title: json['title'] as String,
      description: (json['description'] ?? '') as String,
      status: json['status'] as String,
      points: (json['points'] as num?)?.toInt() ?? 0,
      assignedToName: assigned is Map<String, dynamic> ? assigned['name'] as String? : null,
    );
  }
}
