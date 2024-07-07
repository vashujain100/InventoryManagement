import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './models/customer.dart';
import './models/order.dart';
import './theme.dart';
import 'models/piece.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(PieceAdapter());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twetter App',
      theme: AppTheme.earthTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: DashboardScreen(),
    );
  }
}
