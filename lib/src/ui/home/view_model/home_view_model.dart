import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../data/repositories/local_storage_repository.dart';
import '../../../models/activity.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required LocalStorageRepository localStorageRepository})
      : _localStorageRepository = localStorageRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();

    saveActivity = Command.createAsyncNoParamNoResult(_saveActivity);

    updateActivity = Command.createAsyncNoParamNoResult(_updateActivity);

    removeActivity = Command.createAsyncNoResult(_removeActivity);

    clearNewActivityForm =
        Command.createSyncNoParamNoResult(_clearNewActivityForm);
  }

  late Command<void, void> load;

  late Command<void, void> saveActivity;

  late Command<void, void> updateActivity;
  late Command<int, void> removeActivity;

  late Command<void, void> clearNewActivityForm;

  final LocalStorageRepository _localStorageRepository;

  final newActivityNameTextController = TextEditingController();
  bool newActivityChecked = false;

  Activity get _tempActivity => Activity(
        name: newActivityNameTextController.text,
        checked: newActivityChecked,
      );

  List<Activity> _activities = [];

  UnmodifiableListView get activities => UnmodifiableListView(_activities);

  int get checkedItemsCount =>
      _activities.where((item) => item.checked == true).length;

  Future<void> _load() async {
    _activities = await _localStorageRepository.loadActivities();
    notifyListeners();
  }

  Future<void> _saveActivity() async {
    Activity newActivity = _tempActivity;
    try {
      _activities.add(newActivity);
      await _localStorageRepository.saveActivities(_activities);
    } catch (e) {
      _activities.remove(newActivity);
      throw Exception();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _updateActivity() async {
    await _localStorageRepository.saveActivities(_activities);
    notifyListeners();
  }

  Future<void> _removeActivity(int index) async {
    _activities.removeAt(index);
    await _localStorageRepository.saveActivities(_activities);
    notifyListeners();
  }

  void _clearNewActivityForm() {
    newActivityNameTextController.clear();
    newActivityChecked = false;
  }
}
