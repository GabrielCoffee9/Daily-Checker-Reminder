import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'item.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

Map<DateTime, List<Item>> dailyActivities = {};

List<Item> items = [];

Future<void> saveItems() async {
  final json = items.map((item) => item.toJson()).toList();
  await storage.write(key: 'items', value: jsonEncode(json));

  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  dailyActivities[today] = items;

  saveActivitiesDay(today);
}

Future<List<Item>> loadItems() async {
  final json = await storage.read(key: 'items');
  if (json == null) return [];
  final itemsList = jsonDecode(json) as List<dynamic>;

  return itemsList.map((item) => Item.fromJson(item)).toList();
}

Future<List<Item>> loadActivitiesFromDate(DateTime date) async {
  final rightDate = DateTime(date.year, date.month, date.day);

  final json = await storage.read(
      key: 'daily_activities_${rightDate.millisecondsSinceEpoch}');

  if (json == null) return [];

  final itemsList = jsonDecode(json) as List<dynamic>;

  return itemsList.map((item) => Item.fromJson(item)).toList();
}

void saveActivitiesDay(DateTime day) async {
  final json = dailyActivities[day]!.map((item) => item.toJson()).toList();
  await storage.write(
      key: 'daily_activities_${day.millisecondsSinceEpoch}',
      value: jsonEncode(json));
}

void saveReminder(String reminderName, TimeOfDay time) async {
  final prefs = await SharedPreferences.getInstance();
  final hour = time.hour;
  final minute = time.minute;

  await prefs.setStringList(reminderName, [hour.toString(), minute.toString()]);
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
