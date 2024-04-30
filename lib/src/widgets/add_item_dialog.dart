import 'package:flutter/material.dart';

import '../classes/item.dart';
import '../classes/local_storage.dart';

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
      setState(() {
        saveItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add activity'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                  hintText: 'Enter your activity description here',
                  border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The description is required';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CheckboxListTile(
                title: const Text('Already did it today ?'),
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
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
