import 'package:flutter/material.dart';

import '../models/team_item.dart';
import '../services/api_service.dart';

class TeamProvider extends ChangeNotifier {
  TeamItem? team;
  List<TeamMember> leaderboard = [];
  bool loading = false;

  Future<void> fetchMyTeam(String token) async {
    loading = true;
    notifyListeners();
    try {
      final data = await ApiService.get('/teams/my', token: token);
      team = TeamItem.fromJson(data['team'] as Map<String, dynamic>);
    } catch (_) {
      team = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> createTeam(String token, String name) async {
    final data = await ApiService.post('/teams', body: {'name': name}, token: token);
    team = TeamItem.fromJson(data['team'] as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> joinTeam(String token, String inviteCode) async {
    final data = await ApiService.post('/teams/join/$inviteCode', token: token);
    team = TeamItem.fromJson(data['team'] as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> fetchLeaderboard(String token) async {
    if (team == null) return;
    final data = await ApiService.get('/teams/${team!.id}/leaderboard', token: token);
    leaderboard = (data['leaderboard'] as List<dynamic>)
        .map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }
}
