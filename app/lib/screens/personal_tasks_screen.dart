import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/glass_header.dart';

class PersonalTasksScreen extends StatefulWidget {
  const PersonalTasksScreen({super.key});

  @override
  State<PersonalTasksScreen> createState() => _PersonalTasksScreenState();
}

class _PersonalTasksScreenState extends State<PersonalTasksScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final token = context.read<AuthProvider>().token;
    if (token != null) context.read<TaskProvider>().fetchPersonal(token);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tasks = context.watch<TaskProvider>();
    final token = auth.token;
    if (token == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const GlassHeader(title: 'Personal Tasks', subtitle: 'Your daily focus list'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: _title, decoration: const InputDecoration(labelText: 'Task title')),
                const SizedBox(height: 8),
                TextField(controller: _description, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await tasks.createPersonal(token, _title.text.trim(), _description.text.trim());
                      _title.clear();
                      _description.clear();
                    },
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...tasks.personalTasks.map(
          (task) => Card(
            child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: task.status == 'pending'
                  ? TextButton(
                      onPressed: () => tasks.completeTask(token, task.id),
                      child: const Text('Complete'),
                    )
                  : Text(task.status.toUpperCase()),
            ),
          ),
        ),
      ],
    );
  }
}
