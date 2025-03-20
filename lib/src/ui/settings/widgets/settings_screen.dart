import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/locale_repository.dart';
import '../../../i18n/generated/app_localizations.dart';
import '../../../models/time_of_day_with_context.dart';
import '../view_model/settings_view_model.dart';
import 'date_format_setting.dart';
import 'language_setting.dart';
import 'theme_setting.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String appVersion;

  _updateRemindersText() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        // ignore: use_build_context_synchronously
        widget.viewModel.updateRemindersText.execute(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _updateRemindersText();

    context.read<LocaleRepository>().addListener(() {
      if (mounted) {
        AppLocalizations.delegate
            .load(context.read<LocaleRepository>().currentLocale!)
            .then((appLocalizations) {
          widget.viewModel.resetScheduleNotifications.execute(appLocalizations);
        });

        _updateRemindersText();
      }
    });

    PackageInfo.fromPlatform().then((packageInfo) {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: [
          IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationVersion: appVersion,
                    applicationName: 'Daily Checker',
                    children: [
                      Text(AppLocalizations.of(context)!.made_with_heart)
                    ]);
              })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          LanguageSetting(),
          DateFormatSetting(),
          Text(
            AppLocalizations.of(context)!.set_daily_reminders,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              AppLocalizations.of(context)!.set_reminders_help,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(height: 18),
          ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.viewModel.time1Controller,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.first_reminder,
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              final result = await showTimePicker(
                                  context: context,
                                  initialTime: widget.viewModel.timeOfDay1);

                              if (result != null && mounted) {
                                widget.viewModel.updateTimerReminder1
                                    .execute(TimeOfDayWithContext(
                                        timeOfDay: result,
                                        // ignore: use_build_context_synchronously
                                        context: context));
                                widget.viewModel.resetScheduleNotifications
                                    // ignore: use_build_context_synchronously
                                    .execute(AppLocalizations.of(context));
                              }
                            },
                          ),
                        ),
                        Checkbox(
                            value: widget.viewModel.activeDailyReminder1,
                            onChanged: (value) {
                              widget.viewModel.onChangedActiveDailyReminder1
                                  .execute(value);
                              widget.viewModel.resetScheduleNotifications
                                  .execute(AppLocalizations.of(context));
                            }),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.viewModel.time2Controller,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.second_reminder,
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              final result = await showTimePicker(
                                  context: context,
                                  initialTime: widget.viewModel.timeOfDay2);

                              if (result != null && mounted) {
                                widget.viewModel.updateTimerReminder2
                                    .execute(TimeOfDayWithContext(
                                        timeOfDay: result,
                                        // ignore: use_build_context_synchronously
                                        context: context));
                                widget.viewModel.resetScheduleNotifications
                                    // ignore: use_build_context_synchronously
                                    .execute(AppLocalizations.of(context));
                              }
                            },
                          ),
                        ),
                        Checkbox(
                            value: widget.viewModel.activeDailyReminder2,
                            onChanged: (value) {
                              widget.viewModel.onChangedActiveDailyReminder2
                                  .execute(value);
                              widget.viewModel.resetScheduleNotifications
                                  .execute(AppLocalizations.of(context));
                            }),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.viewModel.time3Controller,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.third_reminder,
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              final result = await showTimePicker(
                                  context: context,
                                  initialTime: widget.viewModel.timeOfDay3);

                              if (result != null && mounted) {
                                widget.viewModel.updateTimerReminder3
                                    .execute(TimeOfDayWithContext(
                                        timeOfDay: result,
                                        // ignore: use_build_context_synchronously
                                        context: context));
                                widget.viewModel.resetScheduleNotifications
                                    // ignore: use_build_context_synchronously
                                    .execute(AppLocalizations.of(context));
                              }
                            },
                          ),
                        ),
                        Checkbox(
                            value: widget.viewModel.activeDailyReminder3,
                            onChanged: (value) {
                              widget.viewModel.onChangedActiveDailyReminder3
                                  .execute(value);
                              widget.viewModel.resetScheduleNotifications
                                  .execute(AppLocalizations.of(context));
                            }),
                      ],
                    ),
                  ],
                );
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: ElevatedButton(
              onPressed: () {
                widget.viewModel.showSimpleNotification.execute(
                    AppLocalizations.of(context)!.notification_example);
              },
              child: Text(AppLocalizations.of(context)!.show_reminder_example),
            ),
          ),
          ThemeSetting(),
        ],
      ),
    );
  }
}
