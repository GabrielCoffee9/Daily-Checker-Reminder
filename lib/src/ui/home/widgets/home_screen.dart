import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/date_format_repository.dart';
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

    widget.viewModel.removeItem.addListener(() {
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
              bottom: 40.0,
            ),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    if (widget.viewModel.items.isNotEmpty) {
                      if (widget.viewModel.checkedItemsCount ==
                          widget.viewModel.items.length) {
                        return Text(
                          AppLocalizations.of(context)!.all_checked,
                          style: Theme.of(context).textTheme.bodyLarge!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        );
                      }

                      return Text(
                        '${widget.viewModel.checkedItemsCount}/${widget.viewModel.items.length} ${AppLocalizations.of(context)!.checked}',
                        style: Theme.of(context).textTheme.bodyLarge!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.tertiary)),
                      );
                    }
                    return SizedBox();
                  },
                ),
                widget.viewModel.items.isEmpty
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
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.viewModel.items.length,
                          itemBuilder: (context, index) {
                            var item = widget.viewModel.items[index];

                            return Dismissible(
                              key: Key(item.text),
                              onDismissed: (direction) {
                                widget.viewModel.removeItem.execute(index);
                              },
                              background: Container(
                                color: Colors.red[400],
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: CheckboxListTile(
                                value: item.checked,
                                title: Text(
                                  item.text,
                                  style: TextStyle(
                                      decoration: item.checked
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                                subtitle: Text(item.doneTime == null
                                    ? AppLocalizations.of(context)!.not_done_yet
                                    : DateFormat(
                                            '${DateFormat(context.watch<DateFormatRepository>().currentDateFormat).format(DateTime.now())} – kk:mm:ss')
                                        .format(item.doneTime!)),
                                onChanged: (value) {
                                  setState(() {
                                    item.checked = value ?? !item.checked;

                                    item.doneTime =
                                        item.checked ? DateTime.now() : null;
                                    widget.viewModel.updateItem.execute();
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
