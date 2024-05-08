import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../classes/local_storage.dart';
import '../../widgets/add_item_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool valuebex = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final loadedItems = await loadItems();
    setState(() {
      items = loadedItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: items.isEmpty
            ? const Center(
                child:
                    Text("Tap the '+' button below to add new activities 😊"),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];

                  return Dismissible(
                    key: Key(item.text),
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        items.removeAt(index);
                        saveItems();
                      });

                      // Then show a snackbar.
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('item dismissed')));
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
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
                          ? 'Not done yet'
                          : DateFormat('dd/MM/yyyy – kk:mm:ss')
                              .format(item.doneTime!)),
                      onChanged: (value) {
                        setState(() {
                          item.checked = value ?? !item.checked;

                          item.doneTime = item.checked ? DateTime.now() : null;
                          saveItems();
                        });
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          items.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: FloatingActionButton(
                    heroTag: 'floatingClear',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              'Are you sure you want to clear all checkboxes ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            TextButton(
                                onPressed: () {
                                  for (var item in items) {
                                    item.checked = false;
                                    item.doneTime = null;
                                  }
                                  setState(() {
                                    saveItems();
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text('Yes'))
                          ],
                        ),
                      );
                    },
                    tooltip: 'Increment',
                    child: const Icon(Icons.cleaning_services),
                  ),
                )
              : const Text(''),
          FloatingActionButton(
            heroTag: 'floatingAdd',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddItemDialog(
                  onItemAdded: (item) {
                    setState(() {
                      items.add(item);
                    });
                  },
                ),
              );
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
