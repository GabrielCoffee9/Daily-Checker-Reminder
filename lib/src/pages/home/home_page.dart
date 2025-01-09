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
                child: Text("Tap the '+' button below to add new activities"),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];

                  return Dismissible(
                    key: Key(item.text),
                    onDismissed: (direction) {
                      setState(() {
                        items.removeAt(index);
                        saveItems();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Activity deleted'),
                          action: SnackBarAction(label: 'Ok', onPressed: () {}),
                        ),
                      );
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
                          : DateFormat('M/d/yyyy – kk:mm:ss')
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
          FloatingActionButton(
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
            tooltip: 'Add a new activity',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
