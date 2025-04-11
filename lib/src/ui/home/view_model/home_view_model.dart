import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../data/repositories/activity_repository.dart';
import '../../../models/activity_log.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();

    saveActivity = Command.createAsyncNoParamNoResult(_saveActivity);

    updateActivity = Command.createAsyncNoResult(_updateActivity);

    removeActivity = Command.createAsyncNoResult(_removeActivity);

    clearNewActivityForm =
        Command.createSyncNoParamNoResult(_clearNewActivityForm);
  }

  late Command<void, void> load;

  late Command<void, void> saveActivity;

  late Command<ActivityLog, void> updateActivity;
  late Command<ActivityLog, void> removeActivity;

  late Command<void, void> clearNewActivityForm;

  final ActivityRepository _activityRepository;

  final newActivityNameTextController = TextEditingController();
  bool newActivityChecked = false;

  ActivityLog get _tempActivity => ActivityLog(
        name: newActivityNameTextController.text,
        checked: newActivityChecked,
        createdAt: ActivityRepository.getCorrectDay(),
        doneTime: newActivityChecked ? DateTime.now() : null,
      );

  List<ActivityLog> _activities = [];

  UnmodifiableListView get activities => UnmodifiableListView(_activities);

  int get checkedItemsCount =>
      _activities.where((item) => item.checked == true).length;

  Future<void> _load() async {
    if (!_activityRepository.isOpen()) {
      await _activityRepository.open();
    }
    _activities = await _activityRepository.getTodayActivities();

    notifyListeners();
  }

  Future<void> _saveActivity() async {
    ActivityLog newActivity = _tempActivity;
    try {
      newActivity = await _activityRepository.insert(newActivity);
      _activities.add(newActivity);
    } catch (e) {
      throw Exception();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _updateActivity(ActivityLog activity) async {
    await _activityRepository.update(activity);
    notifyListeners();
  }

  Future<void> _removeActivity(ActivityLog activity) async {
    if (activity.id == null) {
      throw Exception('Activity doesnt have a Id');
    }
    await _activityRepository.delete(activity);
    _activities.remove(activity);
    notifyListeners();
  }

  void _clearNewActivityForm() {
    newActivityNameTextController.clear();
    newActivityChecked = false;
  }
}
