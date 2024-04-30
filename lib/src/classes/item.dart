class Item {
  final String text;
  bool checked;
  DateTime? doneTime;

  Item({required this.text, this.checked = false, this.doneTime}) {
    if (checked && doneTime == null) {
      doneTime = DateTime.now();
    }
  }

  // Converte Item para JSON
  Map<String, dynamic> toJson() => {
        'text': text,
        'checked': checked,
        'doneTime': doneTime
            ?.millisecondsSinceEpoch, // Converte DateTime para timestamp
      };

  // Converte JSON para Item
  factory Item.fromJson(Map<String, dynamic> json) => Item(
        text: json['text'],
        checked: json['checked'] as bool,
        doneTime: json['doneTime'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['doneTime'])
            : null,
      );
}
