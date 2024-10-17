import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/landing_page.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PawFetchApp(),
    ),
  );
}

class PawFetchApp extends ConsumerWidget {
  const PawFetchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'PawFetch',
      theme: theme,
      home: const PawFetchLanding(),
      debugShowCheckedModeBanner: false,
    );
  }
}