import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  AppUser? _user;
  bool loading = false;
  String? error;

  bool get isAuthenticated => _token != null;
  String? get token => _token;
  AppUser? get user => _user;

  Future<void> restoreSession() async {
    loading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');
      if (savedToken == null) {
        loading = false;
        notifyListeners();
        return;
      }
      _token = savedToken;
      final data = await ApiService.get('/auth/me', token: _token);
      _user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
    } catch (_) {
      _token = null;
      _user = null;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signup(String name, String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await ApiService.post('/auth/signup', body: {
        'name': name,
        'email': email,
        'password': password,
      });
      _token = data['token'] as String;
      _user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await ApiService.post('/auth/login', body: {'email': email, 'password': password});
      _token = data['token'] as String;
      _user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMe() async {
    if (_token == null) return;
    final data = await ApiService.get('/auth/me', token: _token);
    _user = AppUser.fromJson(data['user'] as Map<String, dynamic>);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
