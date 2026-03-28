class AppUser {
  final String id;
  final String name;
  final String email;
  final int points;
  final String teamRole;
  final String? team;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.teamRole,
    required this.team,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['_id']?.toString() ?? json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      points: (json['points'] as num?)?.toInt() ?? 0,
      teamRole: (json['teamRole'] ?? 'none') as String,
      team: json['team']?.toString(),
    );
  }
}
