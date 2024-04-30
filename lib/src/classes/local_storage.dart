import 'dart:convert';

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
  // final today =
  //     DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // final todayActivities = await loadActivitiesFromDate(today);

  // if (todayActivities.isNotEmpty) dailyActivities[today] = todayActivities;
  return itemsList.map((item) => Item.fromJson(item)).toList();
}

// Carregar atividades do SharedPreferences
// void loadAllDaysActivities() async {
//   final prefs = await SharedPreferences.getInstance();
//   final json = prefs.getString('daily_activities_');

//   if (json != null) {
//     dailyActivities = jsonDecode(json) as Map<DateTime, List<Item>>;

//     for (var date in dailyActivities.keys) {
//       dailyActivities[date] = dailyActivities[date]!
//           .map<Item>((item) => Item.fromJson(item as Map<String, dynamic>))
//           .toList();
//     }
//   }

//   debugPrint(dailyActivities.toString());
// }

Future<List<Item>> loadActivitiesFromDate(DateTime date) async {
  final prefs = await SharedPreferences.getInstance();

  final rightDate = DateTime(date.year, date.month, date.day);

  final json =
      prefs.getString('daily_activities_${rightDate.millisecondsSinceEpoch}');

  if (json == null) return [];

  final itemsList = jsonDecode(json) as List<dynamic>;

  return itemsList.map((item) => Item.fromJson(item)).toList();
}

// Salvar atividades no SharedPreferences
void saveActivitiesDay(DateTime day) async {
  final prefs = await SharedPreferences.getInstance();
  final json = dailyActivities[day]!.map((item) => item.toJson()).toList();
  await prefs.setString(
      'daily_activities_${day.millisecondsSinceEpoch}', jsonEncode(json));
}
