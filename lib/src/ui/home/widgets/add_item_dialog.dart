import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/item.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key, required this.onItemAdded});

  final Function(Item) onItemAdded;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  bool _checked = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final item = Item(
        text: _textController.text,
        checked: _checked,
      );
      widget.onItemAdded(item);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.add_activity),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!
                      .enter_your_activity_description,
                  border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.description_required;
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CheckboxListTile(
                title: Text(AppLocalizations.of(context)!.already_did_it_today),
                value: _checked,
                onChanged: (value) {
                  setState(() {
                    _checked = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.discard),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    );
  }
}
