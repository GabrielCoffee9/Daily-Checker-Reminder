import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateFormatRepository extends ChangeNotifier {
  DateFormatRepository() {
    _getDateConfig();
  }

  String currentDateFormat = 'M/d/yy';

  void changeDateFormat({required String dateFormat}) async {
    currentDateFormat = dateFormat;
    saveDateFormatConfig();
    notifyListeners();
  }

  saveDateFormatConfig() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('dateFormatConfig', currentDateFormat);
  }

  void _getDateConfig() async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('dateFormatConfig');

    try {
      if (result == null) return;
      currentDateFormat = result;
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
