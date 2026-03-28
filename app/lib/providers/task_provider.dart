import 'package:flutter/material.dart';

import '../models/task_item.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskItem> personalTasks = [];
  List<TaskItem> teamTasks = [];
  bool loading = false;

  Future<void> fetchPersonal(String token) async {
    loading = true;
    notifyListeners();
    final data = await ApiService.get('/tasks/personal', token: token);
    personalTasks = (data['tasks'] as List<dynamic>)
        .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
        .toList();
    loading = false;
    notifyListeners();
  }

  Future<void> createPersonal(String token, String title, String description) async {
    await ApiService.post('/tasks/personal', body: {'title': title, 'description': description}, token: token);
    await fetchPersonal(token);
  }

  Future<void> fetchTeam(String token, String teamId) async {
    loading = true;
    notifyListeners();
    final data = await ApiService.get('/tasks/team/$teamId', token: token);
    teamTasks = (data['tasks'] as List<dynamic>)
        .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
        .toList();
    loading = false;
    notifyListeners();
  }

  Future<void> assignTeamTask(
    String token, {
    required String teamId,
    required String title,
    required String description,
    required String assignedTo,
    required int points,
  }) async {
    await ApiService.post('/tasks/team', body: {
      'teamId': teamId,
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'points': points,
    }, token: token);
    await fetchTeam(token, teamId);
  }

  Future<void> completeTask(String token, String taskId, {String? teamId}) async {
    await ApiService.patch('/tasks/$taskId/complete', token: token);
    if (teamId != null) {
      await fetchTeam(token, teamId);
    } else {
      await fetchPersonal(token);
    }
  }

  Future<void> approveTask(String token, String taskId, String teamId) async {
    await ApiService.patch('/tasks/$taskId/approve', token: token);
    await fetchTeam(token, teamId);
  }
}
