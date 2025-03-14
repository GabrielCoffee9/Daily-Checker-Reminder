import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../data/repositories/local_storage_repository.dart';
import '../../../data/services/local_notifications.dart';
import '../../../i18n/generated/app_localizations.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required LocalStorageRepository localStorageRepository})
      : _localStorageRepository = localStorageRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();

    resetScheduleNotifications =
        Command.createAsyncNoResult(_resetScheduleNotifications);

    updateTimerReminder1 = Command.createAsyncNoResult(_updateTimerReminder1);
    updateTimerReminder2 = Command.createAsyncNoResult(_updateTimerReminder2);
    updateTimerReminder3 = Command.createAsyncNoResult(_updateTimerReminder3);

    onChangedActiveDailyReminder1 =
        Command.createAsyncNoResult(_onChangedActiveDailyReminder1);
    onChangedActiveDailyReminder2 =
        Command.createAsyncNoResult(_onChangedActiveDailyReminder2);
    onChangedActiveDailyReminder3 =
        Command.createAsyncNoResult(_onChangedActiveDailyReminder3);

    showSimpleNotification =
        Command.createAsyncNoResult(_showSimpleNotification);
  }

  late Command<void, void> onSelected;

  late Command<void, void> load;

  late Command<AppLocalizations, void> resetScheduleNotifications;

  late Command<TimeOfDay, void> updateTimerReminder1;

  late Command<TimeOfDay, void> updateTimerReminder2;

  late Command<TimeOfDay, void> updateTimerReminder3;

  late Command<bool, void> onChangedActiveDailyReminder1;
  late Command<bool, void> onChangedActiveDailyReminder2;
  late Command<bool, void> onChangedActiveDailyReminder3;

  late Command<String, void> showSimpleNotification;

  final LocalStorageRepository _localStorageRepository;

  late TimeOfDay _timeOfDay1;
  late TimeOfDay _timeOfDay2;
  late TimeOfDay _timeOfDay3;

  static String firstReminderKey = 'First Reminder';
  static String secondReminderKey = 'Second Reminder';
  static String thirdReminderKey = 'Third Reminder';

  final _time1Controller = TextEditingController();
  final _time2Controller = TextEditingController();
  final _time3Controller = TextEditingController();

  bool _activeDailyReminder1 = false;
  bool _activeDailyReminder2 = false;
  bool _activeDailyReminder3 = false;

  TextEditingController get time1Controller => _time1Controller;
  TextEditingController get time2Controller => _time2Controller;
  TextEditingController get time3Controller => _time3Controller;

  TimeOfDay get timeOfDay1 => _timeOfDay1;
  TimeOfDay get timeOfDay2 => _timeOfDay2;
  TimeOfDay get timeOfDay3 => _timeOfDay3;

  bool get activeDailyReminder1 => _activeDailyReminder1;
  bool get activeDailyReminder2 => _activeDailyReminder2;
  bool get activeDailyReminder3 => _activeDailyReminder3;

  @override
  void dispose() {
    _time1Controller.dispose();
    _time2Controller.dispose();
    _time3Controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    _timeOfDay1 =
        await _localStorageRepository.loadReminder(firstReminderKey) ??
            TimeOfDay.now();

    _timeOfDay2 =
        await _localStorageRepository.loadReminder(secondReminderKey) ??
            TimeOfDay.now();

    _timeOfDay3 =
        await _localStorageRepository.loadReminder(thirdReminderKey) ??
            TimeOfDay.now();

    _time1Controller.text =
        '${_timeOfDay1.hour.toString()}:${_timeOfDay1.minute.toString()}';
    _time2Controller.text =
        '${_timeOfDay2.hour.toString()}:${_timeOfDay2.minute.toString()}';
    _time3Controller.text =
        '${_timeOfDay3.hour.toString()}:${_timeOfDay3.minute.toString()}';

    final pending = await LocalNotifications.getPendingNotifications();

    for (var element in pending) {
      switch (element.id) {
        case 1:
          _activeDailyReminder1 = true;
        case 2:
          _activeDailyReminder2 = true;

        case 3:
          _activeDailyReminder3 = true;
      }
    }
    notifyListeners();
  }

  Future<void> _resetScheduleNotifications(
      AppLocalizations appLocalizations) async {
    LocalNotifications.cancelNotification(1);
    if (_activeDailyReminder1) {
      LocalNotifications.setDailyScheduleNotification(
        id: 1,
        timeOfDay: _timeOfDay1,
        message: appLocalizations.general_reminder_update_now,
      );
    }

    LocalNotifications.cancelNotification(2);

    if (_activeDailyReminder2) {
      LocalNotifications.setDailyScheduleNotification(
        id: 2,
        timeOfDay: _timeOfDay2,
        message: appLocalizations.general_reminder_update_now,
      );
    }

    LocalNotifications.cancelNotification(3);

    if (_activeDailyReminder3) {
      LocalNotifications.setDailyScheduleNotification(
        id: 3,
        timeOfDay: _timeOfDay3,
        message: appLocalizations.general_reminder_update_now,
      );
    }
  }

  Future<void> _updateTimerReminder1(TimeOfDay newTime) async {
    _timeOfDay1 = newTime;

    time1Controller.text =
        '${_timeOfDay1.hour.toString()}:${_timeOfDay1.minute.toString()}';

    _localStorageRepository.saveReminder(firstReminderKey, _timeOfDay1);
    notifyListeners();
  }

  Future<void> _updateTimerReminder2(TimeOfDay newTime) async {
    _timeOfDay2 = newTime;
    time2Controller.text =
        '${_timeOfDay2.hour.toString()}:${_timeOfDay2.minute.toString()}';

    _localStorageRepository.saveReminder(secondReminderKey, _timeOfDay2);
    notifyListeners();
  }

  Future<void> _updateTimerReminder3(TimeOfDay newTime) async {
    _timeOfDay3 = newTime;
    time3Controller.text =
        '${_timeOfDay3.hour.toString()}:${_timeOfDay3.minute.toString()}';

    _localStorageRepository.saveReminder(thirdReminderKey, _timeOfDay3);
    notifyListeners();
  }

  Future<void> _onChangedActiveDailyReminder1(bool newValue) async {
    _activeDailyReminder1 = newValue;
    notifyListeners();
  }

  Future<void> _onChangedActiveDailyReminder2(bool newValue) async {
    _activeDailyReminder2 = newValue;
    notifyListeners();
  }

  Future<void> _onChangedActiveDailyReminder3(bool newValue) async {
    _activeDailyReminder3 = newValue;
    notifyListeners();
  }

  Future<void> _showSimpleNotification(String message) async {
    await LocalNotifications.showSimpleNotification(
      title: 'Daily Checker Reminder',
      body: message,
      payload: 'empty',
    );
  }
}
