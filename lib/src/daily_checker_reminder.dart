import 'package:flutter/material.dart';
import 'pages/calendar/calendar_page.dart';
import 'pages/home/home_page.dart';
import 'pages/settings/settings.dart';

class DailyCheckerReminder extends StatefulWidget {
  const DailyCheckerReminder({super.key});

  @override
  State<DailyCheckerReminder> createState() => _DailyCheckerReminderState();
}

class _DailyCheckerReminderState extends State<DailyCheckerReminder> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Daily Checker'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
              },
              icon: const Icon(Icons.settings),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today', icon: Icon(Icons.home)),
              Tab(text: 'All Days', icon: Icon(Icons.calendar_today)),
            ],
          ),
        ),
        body: const TabBarView(children: [
          HomePage(),
          CalendarPage(),
        ]),
      ),
    );
  }
}
