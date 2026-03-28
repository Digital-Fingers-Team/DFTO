class TeamMember {
  final String id;
  final String name;
  final String email;
  final int points;
  final String teamRole;

  TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
    required this.teamRole,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
        id: json['_id'].toString(),
        name: json['name'] as String,
        email: json['email'] as String,
        points: (json['points'] as num?)?.toInt() ?? 0,
        teamRole: (json['teamRole'] ?? 'member') as String,
      );
}

class TeamItem {
  final String id;
  final String name;
  final String inviteCode;
  final TeamMember? leader;
  final List<TeamMember> members;

  TeamItem({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.leader,
    required this.members,
  });

  factory TeamItem.fromJson(Map<String, dynamic> json) {
    final members = (json['members'] as List<dynamic>? ?? [])
        .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
        .toList();
    return TeamItem(
      id: json['_id'].toString(),
      name: json['name'] as String,
      inviteCode: (json['inviteCode'] ?? '') as String,
      leader: json['leader'] is Map<String, dynamic>
          ? TeamMember.fromJson(json['leader'] as Map<String, dynamic>)
          : null,
      members: members,
    );
  }
}
