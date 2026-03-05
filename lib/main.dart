import 'package:flutter/material.dart';
import 'navigation/main_navigation.dart';

void main() {
  runApp(const ClinicalCalcApp());
}

class ClinicalCalcApp extends StatelessWidget {
  const ClinicalCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스마트 임상 계산기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, primary: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
