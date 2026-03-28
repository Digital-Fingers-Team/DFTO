import 'package:flutter/material.dart';

const _bg = Color(0xFFF6F7FB);
const _surface = Color(0xFFFFFFFF);
const _primary = Color(0xFF1F6FEB);
const _accent = Color(0xFF10B981);
const _text = Color(0xFF0F172A);

final appTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: _primary,
    secondary: _accent,
    surface: _surface,
    onSurface: _text,
  ),
  scaffoldBackgroundColor: _bg,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: _text,
    centerTitle: false,
  ),
  cardTheme: CardThemeData(
    color: _surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
);
