import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../i18n/generated/app_localizations.dart';
import '../../../models/activity.dart';
import '../../../data/repositories/date_format_repository.dart';
import '../view_model/calendar_view_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.viewModel});

  final CalendarViewModel viewModel;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  @override
  void initState() {
    super.initState();

    widget.viewModel.onSelected.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, snapshot) {
          return Column(
            children: [
              SingleChildScrollView(
                primary: true,
                child: TableCalendar(
                  availableCalendarFormats: {
                    CalendarFormat.twoWeeks:
                        AppLocalizations.of(context)!.two_weeks,
                    CalendarFormat.week: AppLocalizations.of(context)!.week,
                    if (MediaQuery.of(context).size.height > 400)
                      CalendarFormat.month: AppLocalizations.of(context)!.month
                  },
                  locale: AppLocalizations.of(context)!.localeName,
                  calendarStyle: CalendarStyle(
                    rangeHighlightColor: Colors.red,
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(widget.viewModel.selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    widget.viewModel.onChangedSelectedDay.execute(selectedDay);
                    widget.viewModel.onChangedFocusedDay.execute(focusedDay);

                    widget.viewModel.onSelected.execute();
                  },
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: widget.viewModel.focusedDay,
                ),
              ),
              const Divider(),
              if (widget.viewModel.items.isEmpty)
                Center(
                    child:
                        Text(AppLocalizations.of(context)!.no_activity_found)),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.viewModel.items.length,
                  itemBuilder: (context, index) {
                    Activity item = widget.viewModel.items[index];

                    return CheckboxListTile(
                      value: item.checked,
                      title: Text(
                        item.name,
                        style: TextStyle(
                            decoration: item.checked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      subtitle: Text(item.doneTime == null
                          ? AppLocalizations.of(context)!.not_checked
                          : DateFormat(
                                  '${context.watch<DateFormatRepository>().currentDateFormat} – kk:mm:ss')
                              .format(item.doneTime!)),
                      onChanged: (value) {},
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
