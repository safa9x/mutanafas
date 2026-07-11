import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database/database_helper.dart';
import 'screens/splash_screen.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await DatabaseHelper.instance.database;
  final prefs = await SharedPreferences.getInstance();

  await _resetDailyIfNeeded(db, prefs);

  runApp(const ProviderScope(child: MyApp()));
}

/// ================= DAILY RESET SERVICE =================
Future<void> _resetDailyIfNeeded(
  dynamic db,
  SharedPreferences prefs,
) async {
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final lastOpen = prefs.getString('last_open_date');

  if (lastOpen != today) {
    await db.update('worships', {'isCompleted': 0});
    await prefs.setString('last_open_date', today);
  }

  final data = await db.query('worships');

  if (data.isEmpty) {
    await DatabaseHelper.instance.resetIfNewDay();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mutanafas',

      themeMode: themeMode,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8F6F2),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3A7D6B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3A7D6B),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3A7D6B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2937),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}