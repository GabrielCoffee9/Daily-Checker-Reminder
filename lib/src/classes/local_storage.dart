import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'item.dart';

Map<DateTime, List<Item>> dailyActivities = {};

List<Item> items = [];

Future<void> saveItems() async {
  final prefs = await SharedPreferences.getInstance();
  final json = items.map((item) => item.toJson()).toList();
  await prefs.setString('items', jsonEncode(json));

  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  dailyActivities[today] = items;

  saveActivitiesDay(today);
}

Future<List<Item>> loadItems() async {
  final prefs = await SharedPreferences.getInstance();
  final json = prefs.getString('items');
  if (json == null) return [];
  final itemsList = jsonDecode(json) as List<dynamic>;

  return itemsList.map((item) => Item.fromJson(item)).toList();
}

Future<List<Item>> loadActivitiesFromDate(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();

  final rightDate = DateTime(date.year, date.month, date.day);

  final json =
      prefs.getString('daily_activities_${rightDate.millisecondsSinceEpoch}');

  if (json == null) return [];

  final itemsList = jsonDecode(json) as List<dynamic>;

  return itemsList.map((item) => Item.fromJson(item)).toList();
}

void saveActivitiesDay(DateTime day) async {
  final prefs = await SharedPreferences.getInstance();
  final json = dailyActivities[day]!.map((item) => item.toJson()).toList();
  await prefs.setString(
      'daily_activities_${day.millisecondsSinceEpoch}', jsonEncode(json));
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
