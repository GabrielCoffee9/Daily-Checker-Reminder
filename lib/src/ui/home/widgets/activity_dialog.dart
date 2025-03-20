import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

import '../../../i18n/generated/app_localizations.dart';
import '../view_model/home_view_model.dart';

class ActivityDialog extends StatefulWidget {
  const ActivityDialog({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<ActivityDialog> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    widget.viewModel.saveActivity.addListener(_checkAddItemCompleted);

    widget.viewModel.saveActivity.errors.listen(
      (p0, p1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(AppLocalizations.of(context)!.an_error_has_occurred),
          ),
        );
      },
    );
  }

  _checkAddItemCompleted() {
    if (widget.viewModel.saveActivity.results.value.isSuccess) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    widget.viewModel.saveActivity.removeListener(_checkAddItemCompleted);
    widget.viewModel.clearNewActivityForm.execute();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: widget.viewModel.saveActivity,
        builder: (context, snapshot) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.add_activity),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 6,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller:
                          widget.viewModel.newActivityNameTextController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!
                              .activity_description,
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!
                              .description_required;
                        }
                        return null;
                      },
                    ),
                    CheckboxListTile(
                      title: Text(
                          AppLocalizations.of(context)!.already_did_it_today),
                      value: widget.viewModel.newActivityChecked,
                      onChanged: (value) {
                        setState(() {
                          widget.viewModel.newActivityChecked = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context)!.discard),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.viewModel.saveActivity.execute();
                  }
                },
                child: Text(AppLocalizations.of(context)!.confirm),
              ),
            ],
          );
        });
  }
}
