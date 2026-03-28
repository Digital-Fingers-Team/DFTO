import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/team_provider.dart';
import '../widgets/glass_header.dart';
import 'team_details_screen.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final _teamName = TextEditingController();
  final _inviteCode = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final token = context.read<AuthProvider>().token;
    if (token != null) context.read<TeamProvider>().fetchMyTeam(token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final teamProvider = context.watch<TeamProvider>();
    final token = auth.token;
    if (token == null) return const SizedBox.shrink();
    final team = teamProvider.team;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const GlassHeader(title: 'Teams', subtitle: 'Create or join your team'),
        const SizedBox(height: 14),
        if (team == null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(controller: _teamName, decoration: const InputDecoration(labelText: 'Team name')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await teamProvider.createTeam(token, _teamName.text.trim());
                      if (!mounted) return;
                      await context.read<AuthProvider>().refreshMe();
                    },
                    child: const Text('Create Team'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(controller: _inviteCode, decoration: const InputDecoration(labelText: 'Invite code')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      await teamProvider.joinTeam(token, _inviteCode.text.trim());
                      if (!mounted) return;
                      await context.read<AuthProvider>().refreshMe();
                    },
                    child: const Text('Join Team'),
                  ),
                ],
              ),
            ),
          ),
        ] else
          Card(
            child: ListTile(
              title: Text(team.name),
              subtitle: Text('Invite code: ${team.inviteCode}'),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TeamDetailsScreen()));
                },
                child: const Text('Open'),
              ),
            ),
          ),
      ],
    );
  }
}
