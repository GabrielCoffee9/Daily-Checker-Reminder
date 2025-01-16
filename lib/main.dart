import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'src/app_widget.dart';
import 'src/data/services/local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotifications.init();

  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();

  tz.initializeTimeZones();

  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  runApp(const DailyCheckerReminder());
}
