import 'package:flutter/material.dart';

import 'pages/calendar/calendar_page.dart';
import 'pages/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink[700]!),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Daily Checker'),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Today', icon: Icon(Icons.home)),
                Tab(text: 'Other Days', icon: Icon(Icons.calendar_today)),
              ],
            ),
          ),
          body: const TabBarView(children: [
            HomePage(),
            CalendarPage(),
          ]),
        ),
      ),
    );
  }
}
