import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/date_format_repository.dart';
import '../../../i18n/generated/app_localizations.dart';

class DateFormatSetting extends StatelessWidget {
  const DateFormatSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.date_format,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: DropdownMenu(
                initialSelection:
                    context.watch<DateFormatRepository>().currentDateFormat,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'M/d/yy', label: 'M/d/yy'),
                  DropdownMenuEntry(value: 'M/d/yyyy', label: 'M/d/yyyy'),
                  DropdownMenuEntry(value: 'MM/dd/yyyy', label: 'MM/dd/yyyy'),
                  DropdownMenuEntry(value: 'dd/M/yy', label: 'dd/M/yy'),
                  DropdownMenuEntry(value: 'dd/M/yyyy', label: 'dd/M/yyyy'),
                  DropdownMenuEntry(value: 'dd/MM/yy', label: 'dd/MM/yy'),
                  DropdownMenuEntry(value: 'dd/MM/yyyy', label: 'dd/MM/yyyy'),
                ],
                onSelected: (value) async {
                  context
                      .read<DateFormatRepository>()
                      .changeDateFormat(dateFormat: value ?? 'M/d/yyyy');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.current_format),
                  Text(DateFormat(context
                          .watch<DateFormatRepository>()
                          .currentDateFormat)
                      .format(DateTime.now()))
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
