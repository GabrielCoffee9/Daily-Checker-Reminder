import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../data/repositories/local_reminder_repository.dart';
import '../../../data/services/local_notifications.dart';
import '../../../i18n/generated/app_localizations.dart';
import '../../../models/time_of_day_with_context.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required LocalReminderRepository localReminderRepository})
      : _localReminderRepository = localReminderRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();

    resetScheduleNotifications =
        Command.createAsyncNoResult(_resetScheduleNotifications);

    updateRemindersText = Command.createAsyncNoResult(_updateRemindersText);

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

  late Command<BuildContext, void> updateRemindersText;

  late Command<TimeOfDayWithContext, void> updateTimerReminder1;

  late Command<TimeOfDayWithContext, void> updateTimerReminder2;

  late Command<TimeOfDayWithContext, void> updateTimerReminder3;

  late Command<bool, void> onChangedActiveDailyReminder1;
  late Command<bool, void> onChangedActiveDailyReminder2;
  late Command<bool, void> onChangedActiveDailyReminder3;

  late Command<String, void> showSimpleNotification;

  final LocalReminderRepository _localReminderRepository;

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
        await _localReminderRepository.loadReminder(firstReminderKey) ??
            TimeOfDay.now();

    _timeOfDay2 =
        await _localReminderRepository.loadReminder(secondReminderKey) ??
            TimeOfDay.now();

    _timeOfDay3 =
        await _localReminderRepository.loadReminder(thirdReminderKey) ??
            TimeOfDay.now();

    _time1Controller.text =
        '${_timeOfDay1.hour.toString()}:${_timeOfDay1.minute.toString()}';
    _time2Controller.text =
        '${_timeOfDay2.hour.toString()}:${_timeOfDay2.minute.toString()}';
    _time3Controller.text =
        '${_timeOfDay3.hour.toString()}:${_timeOfDay3.minute.toString()}';

    final pendingNotifications =
        await LocalNotifications.getPendingNotifications();

    for (var notification in pendingNotifications) {
      switch (notification.id) {
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

  Future<void> _updateRemindersText(BuildContext context) async {
    time1Controller.text = _timeOfDay1.format(context);
    time2Controller.text = _timeOfDay2.format(context);
    time3Controller.text = _timeOfDay3.format(context);
    notifyListeners();
  }

  Future<void> _updateTimerReminder1(TimeOfDayWithContext newTime) async {
    _timeOfDay1 = newTime.timeOfDay;

    time1Controller.text = newTime.timeOfDay.format(newTime.context);

    _localReminderRepository.saveReminder(firstReminderKey, _timeOfDay1);
    notifyListeners();
  }

  Future<void> _updateTimerReminder2(TimeOfDayWithContext newTime) async {
    _timeOfDay2 = newTime.timeOfDay;

    time2Controller.text = newTime.timeOfDay.format(newTime.context);

    _localReminderRepository.saveReminder(secondReminderKey, _timeOfDay2);
    notifyListeners();
  }

  Future<void> _updateTimerReminder3(TimeOfDayWithContext newTime) async {
    _timeOfDay3 = newTime.timeOfDay;

    time3Controller.text = newTime.timeOfDay.format(newTime.context);

    _localReminderRepository.saveReminder(thirdReminderKey, _timeOfDay3);
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
