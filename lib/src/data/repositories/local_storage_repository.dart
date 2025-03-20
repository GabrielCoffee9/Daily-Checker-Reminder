import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/activity.dart';

class LocalStorageRepository {
  late final FlutterSecureStorage storage;

  LocalStorageRepository() {
    storage = FlutterSecureStorage(
        aOptions: const AndroidOptions(encryptedSharedPreferences: true));
  }

  Future<void> saveActivities(List<Activity> items) async {
    final json = items.map((item) => item.toJson()).toList();
    await storage.write(key: 'items', value: jsonEncode(json));

    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    await storage.write(
        key: 'daily_activities_${today.millisecondsSinceEpoch}',
        value: jsonEncode(json));
  }

  Future<List<Activity>> loadActivities() async {
    final json = await storage.read(key: 'items');
    if (json == null) return [];
    final itemsList = jsonDecode(json) as List<dynamic>;

    var result = itemsList.map((item) => Activity.fromJson(item)).toList();

    for (var item in result) {
      if (item.checked && item.doneTime != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final timeDiferrence = item.doneTime!.isBefore(today);
        if (timeDiferrence) {
          item.checked = false;
          item.doneTime = null;
        }
      }
    }

    return result;
  }

  Future<List<Activity>> loadActivitiesFromDate(DateTime date) async {
    final rightDate = DateTime(date.year, date.month, date.day);

    final json = await storage.read(
        key: 'daily_activities_${rightDate.millisecondsSinceEpoch}');

    if (json == null) return [];

    final itemsList = jsonDecode(json) as List<dynamic>;

    return itemsList.map((item) => Activity.fromJson(item)).toList();
  }

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
