import 'package:daily_checker_reminder/src/classes/local_notifications.dart';
import 'package:flutter/material.dart';

import 'src/app_widget.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotifications.init();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

  runApp(const MyApp());
}
