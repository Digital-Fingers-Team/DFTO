import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/team_provider.dart';

class TeamDetailsScreen extends StatefulWidget {
  const TeamDetailsScreen({super.key});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _points = TextEditingController(text: '10');
  String? _assignedMemberId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    final team = context.read<TeamProvider>().team;
    if (auth.token != null && team != null) {
      context.read<TaskProvider>().fetchTeam(auth.token!, team.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final team = context.watch<TeamProvider>().team;
    final tasks = context.watch<TaskProvider>();
    if (auth.token == null || team == null) return const SizedBox.shrink();

    final isLeader = auth.user?.teamRole == 'leader';
    return Scaffold(
      appBar: AppBar(title: Text(team.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Text('Invite Code: ${team.inviteCode}'))),
          const SizedBox(height: 8),
          if (isLeader)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(controller: _title, decoration: const InputDecoration(labelText: 'Task title')),
                    const SizedBox(height: 8),
                    TextField(controller: _description, decoration: const InputDecoration(labelText: 'Description')),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _assignedMemberId,
                      items: team.members
                          .map((m) => DropdownMenuItem<String>(value: m.id, child: Text('${m.name} (${m.teamRole})')))
                          .toList(),
                      onChanged: (v) => setState(() => _assignedMemberId = v),
                      decoration: const InputDecoration(labelText: 'Assign to'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _points,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Points'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _assignedMemberId == null
                          ? null
                          : () async {
                              await tasks.assignTeamTask(
                                auth.token!,
                                teamId: team.id,
                                title: _title.text.trim(),
                                description: _description.text.trim(),
                                assignedTo: _assignedMemberId!,
                                points: int.tryParse(_points.text) ?? 0,
                              );
                            },
                      child: const Text('Assign Task'),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          ...tasks.teamTasks.map(
            (t) => Card(
              child: ListTile(
                title: Text(t.title),
                subtitle: Text('${t.description}\nAssigned: ${t.assignedToName ?? '-'} • ${t.points} pts'),
                isThreeLine: true,
                trailing: isLeader
                    ? (t.status == 'completed'
                        ? TextButton(
                            onPressed: () => tasks.approveTask(auth.token!, t.id, team.id),
                            child: const Text('Approve'),
                          )
                        : Text(t.status.toUpperCase()))
                    : (t.status == 'pending'
                        ? TextButton(
                            onPressed: () => tasks.completeTask(auth.token!, t.id, teamId: team.id),
                            child: const Text('Complete'),
                          )
                        : Text(t.status.toUpperCase())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
