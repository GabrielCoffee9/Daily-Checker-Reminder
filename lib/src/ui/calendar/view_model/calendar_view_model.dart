import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../data/repositories/local_storage_repository.dart';
import '../../../models/item.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel({required LocalStorageRepository localStorageRepository})
      : _localStorageRepository = localStorageRepository {
    onChangedSelectedDay = Command.createAsyncNoResult(_onChangedSelectedDay);
    onChangedFocusedDay = Command.createAsyncNoResult(_onChangedFocusedDay);

    onSelected = Command.createAsyncNoParamNoResult(_onSelected);
  }

  late Command<DateTime, void> onChangedSelectedDay;

  late Command<DateTime, void> onChangedFocusedDay;

  late Command<void, void> onSelected;

  final LocalStorageRepository _localStorageRepository;

  DateTime? _selectedDay;

  DateTime? get selectedDay => _selectedDay;

  DateTime get focusedDay => _focusedDay;

  DateTime _focusedDay = DateTime.now();

  DateTime? _selectDayPure;

  List<Item> _items = [];

  UnmodifiableListView get items => UnmodifiableListView(_items);

  Future<void> _onSelected() async {
    _selectDayPure = _selectedDay == null
        ? DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day)
        : DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

    _items =
        await _localStorageRepository.loadActivitiesFromDate(_selectDayPure!);
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
