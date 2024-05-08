import 'package:daily_checker_reminder/src/daily_checker_reminder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Checker Reminder',
      theme: ThemeData(
        textTheme: GoogleFonts.notoSerifTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink[500]!),
        useMaterial3: true,
      ),
      home: const DailyCheckerReminder(),
    );
  }
}
