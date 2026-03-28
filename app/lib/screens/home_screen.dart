import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'dashboard_screen.dart';
import 'leaderboard_screen.dart';
import 'personal_tasks_screen.dart';
import 'teams_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final pages = const [DashboardScreen(), PersonalTasksScreen(), TeamsScreen(), LeaderboardScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.checklist_rtl), label: 'Personal'),
          NavigationDestination(icon: Icon(Icons.groups_2_outlined), label: 'Teams'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), label: 'Leaderboard'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<AuthProvider>().logout(),
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
      ),
    );
  }
}
