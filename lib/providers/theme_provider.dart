import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backgroundColorProvider = Provider<Color>((ref) => Colors.brown[300]!);
final darkBrownColorProvider = Provider<Color>((ref) => Colors.brown[700]!);
final lightBrownColorProvider = Provider<Color>((ref) => Colors.brown[200]!);

final themeProvider = Provider<ThemeData>((ref) {
  final backgroundColor = ref.watch(backgroundColorProvider);
  final darkBrown = ref.watch(darkBrownColorProvider);
  final lightBrown = ref.watch(lightBrownColorProvider);

  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.dark(
      primary: darkBrown,
      secondary: lightBrown,
      background: backgroundColor,
    ),
    textTheme: TextTheme(
      headlineLarge: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        color: darkBrown,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,  // Increased from 16
        fontWeight: FontWeight.bold,
        color: darkBrown,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightBrown,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: darkBrown, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: darkBrown, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: darkBrown, width: 2),
      ),
      prefixIconColor: darkBrown,
      hintStyle: TextStyle(color: darkBrown.withOpacity(0.7)),
    ),
  );
});