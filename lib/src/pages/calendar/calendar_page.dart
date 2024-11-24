import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../classes/item.dart';
import '../../classes/local_storage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime? _selectedDay;

  DateTime _focusedDay = DateTime.now();

  DateTime? _selecteDayPure;

  @override
  void initState() {
    super.initState();
    _selected();
  }

  void _selected() async {
    _selecteDayPure = _selectedDay == null
        ? DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day)
        : DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);

    dailyActivities[_selecteDayPure!] =
        await loadActivitiesFromDate(_selecteDayPure!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
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
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
              _selected();
            });
          },
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: dailyActivities[_selecteDayPure]?.length ?? 0,
          itemBuilder: (context, index) {
            Item item = dailyActivities[_selecteDayPure]![index];

            return CheckboxListTile(
              value: item.checked,
              title: Text(
                item.text,
                style: TextStyle(
                    decoration: item.checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              subtitle: Text(item.doneTime == null
                  ? "It wasn't done"
                  : DateFormat('dd/MM/yyyy – kk:mm:ss').format(item.doneTime!)),
              onChanged: (value) {},
            );
          },
        ),
      ],
    );
  }
}
