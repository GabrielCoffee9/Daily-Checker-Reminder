import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/date_format_repository.dart';
import '../../../i18n/generated/app_localizations.dart';
import '../../../models/activity_log.dart';
import '../view_model/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});
  final HomeViewModel viewModel;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.removeActivity.addListener(() {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(AppLocalizations.of(context)!.activity_deleted),
            action: SnackBarAction(label: 'Ok', onPressed: () {}),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (widget.viewModel.activities.isNotEmpty) {
                      if (widget.viewModel.checkedItemsCount ==
                          widget.viewModel.activities.length) {
                        return Text(
                          AppLocalizations.of(context)!.all_checked,
                          style: Theme.of(context).textTheme.bodyLarge!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        );
                      }

                      return Text(
                        '${widget.viewModel.checkedItemsCount}/${widget.viewModel.activities.length} ${AppLocalizations.of(context)!.checked}',
                        style: Theme.of(context).textTheme.bodyLarge!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.tertiary)),
                      );
                    }
                    return SizedBox();
                  },
                ),
                widget.viewModel.activities.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.tap_to_add,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 54),
                          shrinkWrap: true,
                          itemCount: widget.viewModel.activities.length,
                          itemBuilder: (context, index) {
                            ActivityLog activity =
                                widget.viewModel.activities[index];

                            return Dismissible(
                              key: UniqueKey(),
                              onDismissed: (direction) {
                                widget.viewModel.removeActivity
                                    .execute(activity);
                              },
                              background: Container(
                                color: Colors.red[400],
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: CheckboxListTile(
                                value: activity.checked,
                                title: Text(
                                  activity.name,
                                  style: TextStyle(
                                      decoration: activity.checked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                                subtitle: Text(activity.doneTime == null
                                    ? AppLocalizations.of(context)!.not_done_yet
                                    : DateFormat(
                                            '${DateFormat(context.watch<DateFormatRepository>().currentDateFormat).format(DateTime.now())} – kk:mm:ss')
                                        .format(activity.doneTime!)),
                                onChanged: (value) {
                                  setState(() {
                                    activity.checked =
                                        value ?? !activity.checked;

                                    activity.doneTime = activity.checked
                                        ? DateTime.now()
                                        : null;
                                    widget.viewModel.updateActivity
                                        .execute(activity);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          );
        });
  }
}
