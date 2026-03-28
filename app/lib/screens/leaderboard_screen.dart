import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/glass_header.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    final teamProvider = context.read<TeamProvider>();
    if (auth.token != null) {
      teamProvider.fetchMyTeam(auth.token!).then((_) {
        teamProvider.fetchLeaderboard(auth.token!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = context.watch<TeamProvider>();
    final board = teamProvider.leaderboard;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const GlassHeader(title: 'Leaderboard', subtitle: 'Points after leader approval'),
        const SizedBox(height: 12),
        if (teamProvider.team == null)
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Join a team to see leaderboard.')))
        else
          ...List.generate(board.length, (i) {
            final member = board[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(member.name),
                subtitle: Text(member.teamRole.toUpperCase()),
                trailing: Text('${member.points} pts'),
              ),
            );
          }),
      ],
    );
  }
}
