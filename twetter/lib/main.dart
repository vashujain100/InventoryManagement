import 'package:flutter/material.dart';

import './theme.dart';
import 'screens/dashboard.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twetter App',
      theme: lightTheme,
      home: DashboardScreen(),
    );
  }
}
