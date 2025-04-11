import 'package:sqflite/sqflite.dart';

import '../../models/daily_activity.dart';
import '../../models/activity_log.dart';

const String _databaseName = "daily_checker_database";

class ActivityRepository {
  Database? _db;

  ActivityRepository() {
    open();
  }

  /// returns a [DateTime] constructed with only the Year, Month and Day parameters for exact day.
  ///
  /// If [targetDate] is null, returns today.
  static DateTime getCorrectDay({DateTime? targetDate}) {
    if (targetDate != null) {
      return DateTime(targetDate.year, targetDate.month, targetDate.day);
    }

    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  /// Returns whether the database is open.
  ///
  /// If this function returns false, the [open] function must be called before attempting to use the repository.
  bool isOpen() => _db != null;

  Future close() async => _db?.close();

  Future<void> open() async {
    _db =
        await openDatabase(_databaseName, version: 1, onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE $tableDailyActivity (
          $columnDailyId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnDailyName TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableActivityLog (
          $columnLogId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnLogActivityId INTEGER,
          $columnLogName TEXT NOT NULL,
          $columnLogChecked INTEGER NOT NULL,
          $columnLogDoneTime INTEGER,
          $columnLogCreatedAt INTEGER NOT NULL,
          FOREIGN KEY($columnLogActivityId) REFERENCES $tableDailyActivity($columnDailyId) ON DELETE SET NULL
        )
      ''');
    });
  }

  Future<ActivityLog> insert(ActivityLog log) async {
    return await _db!.transaction((transaction) async {
      final dailyActivity = DailyActivity(name: log.name);
      dailyActivity.id =
          await transaction.insert(tableDailyActivity, dailyActivity.toMap());

      log.activityId = dailyActivity.id;

      log.id = await transaction.insert(tableActivityLog, log.toMap());

      return log;
    });
  }

  Future<int> update(ActivityLog log) async {
    return await _db!.transaction((transaction) async {
      final count = await transaction.update(
        tableDailyActivity,
        DailyActivity(id: log.activityId, name: log.name).toMap(),
        where: '$columnDailyId = ?',
        whereArgs: [log.activityId],
      );

      await transaction.update(
        tableActivityLog,
        log.toMap(),
        where: '$columnLogId = ?',
        whereArgs: [log.id],
      );

      return count;
    });
  }

  Future<int> delete(ActivityLog log) async {
    return await _db!.transaction((transaction) async {
      await transaction.delete(
        tableActivityLog,
        where: '$columnLogId = ?',
        whereArgs: [log.id],
      );

      return await transaction.delete(
        tableDailyActivity,
        where: '$columnDailyId = ?',
        whereArgs: [log.activityId],
      );
    });
  }

  Future<List<DailyActivity>> getAllDailyActivities() async {
    final maps = await _db!.query(tableDailyActivity);
    return maps.map((map) => DailyActivity.fromMap(map)).toList();
  }

  Future<List<ActivityLog>> getActivityLogsFromDay({DateTime? date}) async {
    final correctedDay = getCorrectDay(targetDate: date);
    final maps = await _db!.query(
      tableActivityLog,
      where: '$columnLogCreatedAt = ?',
      whereArgs: [correctedDay.millisecondsSinceEpoch],
    );
    return maps.map((map) => ActivityLog.fromMap(map)).toList();
  }

  Future<List<ActivityLog>> getTodayActivities() async {
    final logs = await getActivityLogsFromDay();

    if (logs.isNotEmpty) {
      return logs;
    }

    final dailyActivities = await getAllDailyActivities();
    List<ActivityLog> newActivityLogs = [];

    final targetDay = getCorrectDay();

    for (var dailyActivity in dailyActivities) {
      final log = ActivityLog(
        activityId: dailyActivity.id,
        name: dailyActivity.name,
        checked: false,
        doneTime: null,
        createdAt: targetDay,
      );

      log.id = await _db!.insert(tableActivityLog, log.toMap());
      newActivityLogs.add(log);
    }

    return newActivityLogs;
  }
}
