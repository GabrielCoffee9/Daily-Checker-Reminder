import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository extends ChangeNotifier {
  Color themeSeedColor;

  ThemeRepository({this.themeSeedColor = const Color(0xff7c4dff)}) {
    _getThemeConfig();
  }

  void changeThemeColor({required Color newColor}) async {
    themeSeedColor = newColor;
    saveThemeConfig();
    notifyListeners();
  }

  saveThemeConfig() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('themeColorConfig', themeSeedColor.toARGB32());
  }

  void _getThemeConfig() async {
    final prefs = await SharedPreferences.getInstance();
    var result = prefs.getInt('themeColorConfig');

    try {
      if (result == null) return;

      Color getColor = Color(result);
      themeSeedColor = getColor;
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
