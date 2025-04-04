const String tableDailyActivity = 'daily_activity';
const String columnDailyId = 'id';
const String columnDailyName = 'name';

class DailyActivity {
  int? id;
  String name;

  DailyActivity({
    this.id,
    required this.name,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory DailyActivity.fromMap(Map<String, Object?> map) {
    return DailyActivity(
      id: map['id'] as int?,
      name: map['name'] as String,
    );
  }
}
