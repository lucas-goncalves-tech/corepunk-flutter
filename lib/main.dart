import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/presentation/pages/main_navigation_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CorepunkApp(),
    ),
  );
}

class CorepunkApp extends StatelessWidget {
  const CorepunkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corepunk Help',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationPage(),
    );
  }
}
