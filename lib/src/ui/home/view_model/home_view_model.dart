import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../data/repositories/local_storage_repository.dart';
import '../../../models/item.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required LocalStorageRepository localStorageRepository})
      : _localStorageRepository = localStorageRepository {
    load = Command.createAsyncNoParamNoResult(_load)..execute();

    addItem = Command.createAsyncNoResult(_addItem);

    updateItem = Command.createAsyncNoParamNoResult(_updateItem);

    removeItem = Command.createAsyncNoResult(_removeItem);
  }

  late Command<void, void> load;

  late Command<Item, void> addItem;

  late Command<void, void> updateItem;
  late Command<int, void> removeItem;

  final LocalStorageRepository _localStorageRepository;

  List<Item> _items = [];

  UnmodifiableListView get items => UnmodifiableListView(_items);

  int get checkedItemsCount =>
      _items.where((item) => item.checked == true).length;

  Future<void> _load() async {
    _items = await _localStorageRepository.loadItems();
    notifyListeners();
  }

  Future<void> _addItem(Item newItem) async {
    _items.add(newItem);
    await _localStorageRepository.saveItems(_items);
    notifyListeners();
  }

  Future<void> _updateItem() async {
    await _localStorageRepository.saveItems(_items);
    notifyListeners();
  }

  Future<void> _removeItem(int index) async {
    _items.removeAt(index);
    await _localStorageRepository.saveItems(_items);
    notifyListeners();
  }
}
