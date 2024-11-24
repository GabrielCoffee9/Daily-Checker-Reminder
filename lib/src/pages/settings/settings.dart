import 'package:daily_checker_reminder/src/app_widget.dart';
import 'package:daily_checker_reminder/src/classes/local_notifications.dart';
import 'package:daily_checker_reminder/src/classes/local_storage.dart';
import 'package:daily_checker_reminder/src/providers/theme_provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TimeOfDay _timeOfDay1;
  late TimeOfDay _timeOfDay2;
  late TimeOfDay _timeOfDay3;

  static String firstReminderKey = 'First Reminder';
  static String secondReminderKey = 'Second Reminder';
  static String thirdReminderKey = 'Third Reminder';

  final _time1Controller = TextEditingController();
  final _time2Controller = TextEditingController();
  final _time3Controller = TextEditingController();

  bool? _activeDailyReminder1 = false;
  bool? _activeDailyReminder2 = false;
  bool? _activeDailyReminder3 = false;

  // late Color screenPickerColor;

  @override
  void initState() {
    super.initState();
    loadTimers();
    // screenPickerColor = Colors.blue;
  }

  void loadTimers() async {
    _timeOfDay1 = await loadReminder(firstReminderKey) ?? TimeOfDay.now();
    _timeOfDay2 = await loadReminder(secondReminderKey) ?? TimeOfDay.now();
    _timeOfDay3 = await loadReminder(thirdReminderKey) ?? TimeOfDay.now();

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
          setState(() {
            _activeDailyReminder1 = true;
          });
          break;
        case 2:
          setState(() {
            _activeDailyReminder2 = true;
          });
          break;
        case 3:
          setState(() {
            _activeDailyReminder3 = true;
          });
          break;
      }
    }
  }

  @override
  void dispose() {
    _time1Controller.dispose();
    _time2Controller.dispose();
    _time3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            'This timers are used to remind you to update your checklists during the day.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _time1Controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'First Daily Reminder',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final result = await _selectedTime(
                      firstReminderKey,
                      _timeOfDay1,
                      _time1Controller,
                    );
                    if (result != null) {
                      _timeOfDay1 = result;
                      if (_activeDailyReminder1 ?? false) {
                        LocalNotifications.cancelNotification(1);
                        LocalNotifications.setDailyScheduleNotification(
                          id: 1,
                          timeOfDay: _timeOfDay1,
                        );
                      }
                    }
                  },
                ),
              ),
              Checkbox(
                  value: _activeDailyReminder1,
                  onChanged: (value) async {
                    setState(() {
                      _activeDailyReminder1 = value;
                    });

                    if (value ?? false) {
                      LocalNotifications.setDailyScheduleNotification(
                        id: 1,
                        timeOfDay: _timeOfDay1,
                      );
                    } else {
                      LocalNotifications.cancelNotification(1);
                    }
                  }),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _time2Controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Second Daily Reminder',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final result = await _selectedTime(
                      secondReminderKey,
                      _timeOfDay2,
                      _time2Controller,
                    );
                    if (result != null) {
                      _timeOfDay2 = result;
                      if (_activeDailyReminder2 ?? false) {
                        LocalNotifications.cancelNotification(2);
                        LocalNotifications.setDailyScheduleNotification(
                          id: 2,
                          timeOfDay: _timeOfDay2,
                        );
                      }
                    }
                  },
                ),
              ),
              Checkbox(
                  value: _activeDailyReminder2,
                  onChanged: (value) {
                    setState(() {
                      _activeDailyReminder2 = value;
                      if (_activeDailyReminder2!) {
                        LocalNotifications.setDailyScheduleNotification(
                          id: 2,
                          timeOfDay: _timeOfDay2,
                        );
                      } else {
                        LocalNotifications.cancelNotification(2);
                      }
                    });
                  }),
            ],
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  controller: _time3Controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Third Daily Reminder',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final result = await _selectedTime(
                      thirdReminderKey,
                      _timeOfDay3,
                      _time3Controller,
                    );

                    if (result != null) {
                      _timeOfDay3 = result;
                      if (_activeDailyReminder3 ?? false) {
                        LocalNotifications.cancelNotification(3);
                        LocalNotifications.setDailyScheduleNotification(
                          id: 3,
                          timeOfDay: _timeOfDay3,
                        );
                      }
                    }
                  },
                ),
              ),
              Checkbox(
                  value: _activeDailyReminder3,
                  onChanged: (value) {
                    setState(() {
                      _activeDailyReminder3 = value;
                      if (_activeDailyReminder3!) {
                        LocalNotifications.setDailyScheduleNotification(
                          id: 3,
                          timeOfDay: _timeOfDay3,
                        );
                      } else {
                        LocalNotifications.cancelNotification(3);
                      }
                    });
                  }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: ElevatedButton(
              onPressed: () {
                LocalNotifications.showSimpleNotification(
                  title: 'Daily Checker Reminder 🧠',
                  body: 'This is an notification example! Did you like it 🙂?',
                  payload: 'empty',
                );
              },
              child: const Text('Show me an example of a reminder'),
            ),
          ),
          Text(
            'App color theme',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                elevation: 2,
                child: ColorPicker(
                  enableShadesSelection: false,
                  pickersEnabled: const <ColorPickerType, bool>{
                    ColorPickerType.both: false,
                    ColorPickerType.primary: false,
                    ColorPickerType.accent: true,
                    ColorPickerType.bw: false,
                    ColorPickerType.custom: false,
                    ColorPickerType.customSecondary: false,
                    ColorPickerType.wheel: false,
                  },
                  color: context.watch<ThemeProvider>().themeSeedColor,
                  onColorChanged: (Color color) {
                    context
                        .read<ThemeProvider>()
                        .changeThemeColor(newColor: color);
                  },
                  width: 44,
                  height: 44,
                  borderRadius: 22,
                ),
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationVersion: '1.0.1',
                  applicationName: 'Daily Checker',
                  children: [const Text('Made with ❤️ by Gabriel Café')]);
            },
            child: const Text('About the app'),
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _selectedTime(String reminderName, TimeOfDay time,
      TextEditingController timerEditController) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null) {
      setState(() {
        timerEditController.text =
            '${picked.hour.toString()}:${picked.minute.toString()}';

        saveReminder(reminderName, picked);
      });
      return picked;
    }
    return null;
  }
}
