import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'providers/team_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(const DftoApp());
}

class DftoApp extends StatelessWidget {
  const DftoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..restoreSession()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'DFTO Task Manager',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.loading && !auth.isAuthenticated) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return auth.isAuthenticated ? const HomeScreen() : const AuthScreen();
          },
        ),
      ),
    );
  }
}
