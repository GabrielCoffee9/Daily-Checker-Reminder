import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../models/activity_log.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel({required ActivityRepository activityRepository})
      : _activityRepository = activityRepository {
    onChangedSelectedDay = Command.createAsyncNoResult(_onChangedSelectedDay);
    onChangedFocusedDay = Command.createAsyncNoResult(_onChangedFocusedDay);

    onSelected = Command.createAsyncNoParamNoResult(_onSelected);
  }

  late Command<DateTime, void> onChangedSelectedDay;

  late Command<DateTime, void> onChangedFocusedDay;

  late Command<void, void> onSelected;

  final ActivityRepository _activityRepository;

  DateTime? _selectedDay;

  DateTime? get selectedDay => _selectedDay;

  DateTime get focusedDay => _focusedDay;

  DateTime _focusedDay = DateTime.now();

  DateTime? _selectExactDay;

  List<ActivityLog> _items = [];

  UnmodifiableListView get items => UnmodifiableListView(_items);

  Future<void> _onSelected() async {
    if (!_activityRepository.isOpen()) {
      await _activityRepository.open();
    }
    _selectExactDay = _selectedDay == null
        ? DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day)
        : DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

    _items = await _activityRepository.getActivityLogsFromDay(
        date: _selectExactDay!);
    notifyListeners();
  }

  Future<void> _onChangedSelectedDay(DateTime newSelectedDay) async {
    _selectedDay = newSelectedDay;
    notifyListeners();
  }

  Future<void> _onChangedFocusedDay(DateTime newFocusedDay) async {
    _focusedDay = newFocusedDay;
    notifyListeners();
  }
}
