import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalReminderRepository {
  void saveReminder(String reminderName, TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    final hour = time.hour;
    final minute = time.minute;

    await prefs
        .setStringList(reminderName, [hour.toString(), minute.toString()]);
  }

  Future<TimeOfDay?> loadReminder(String reminderName) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(reminderName);

    if (stringList != null && stringList.length == 2) {
      final instance = TimeOfDay(
          hour: int.tryParse(stringList[0])!,
          minute: int.tryParse(stringList[1])!);
      return instance;
    }
    return null;
  }
}
