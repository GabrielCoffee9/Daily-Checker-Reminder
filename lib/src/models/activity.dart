class Activity {
  final String name;
  bool checked;
  DateTime? doneTime;

  Activity({required this.name, this.checked = false, this.doneTime}) {
    if (checked && doneTime == null) {
      doneTime = DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => {
        'text': name,
        'checked': checked,
        'doneTime': doneTime?.millisecondsSinceEpoch,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        name: json['text'],
        checked: json['checked'] as bool,
        doneTime: json['doneTime'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['doneTime'])
            : null,
      );
}
