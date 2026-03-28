import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/glass_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GlassHeader(
          title: 'Hi, ${user.name}',
          subtitle: 'Role: ${user.teamRole.toUpperCase()} • Points: ${user.points}',
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              user.team == null
                  ? 'You are not in a team yet. Create or join one from Teams page.'
                  : 'You are part of a team. Complete tasks and earn approved points.',
            ),
          ),
        ),
      ],
    );
  }
}
