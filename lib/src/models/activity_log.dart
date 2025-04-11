const String tableActivityLog = 'activity_log';
const String columnLogId = 'id';
const String columnLogActivityId = 'activity_id';
const String columnLogName = 'name';
const String columnLogChecked = 'checked';
const String columnLogDoneTime = 'doneTime';
const String columnLogCreatedAt = 'createdAt';

class ActivityLog {
  int? id;
  int? activityId;
  String name;
  bool checked;
  DateTime? doneTime;
  DateTime createdAt;

  ActivityLog({
    this.id,
    this.activityId,
    required this.name,
    this.checked = false,
    this.doneTime,
    required this.createdAt,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'name': name,
      'checked': checked ? 1 : 0,
      'doneTime': doneTime?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ActivityLog.fromMap(Map<String, Object?> map) {
    return ActivityLog(
      id: map['id'] as int?,
      activityId: map['activity_id'] as int?,
      name: map['name'] as String,
      checked: map['checked'] == 1,
      doneTime: map['doneTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['doneTime'] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }
}
