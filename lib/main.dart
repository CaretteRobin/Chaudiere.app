import 'package:flutter/material.dart';
import 'screens/master_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ChaudiereApp());

class ChaudiereApp extends StatelessWidget {
  const ChaudiereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaudière',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MasterScreen(),
    );
  }
}
