import 'package:flutter/material.dart';

class ReorderableListTile extends StatefulWidget {
  const ReorderableListTile({super.key});

  @override
  State<ReorderableListTile> createState() => _ReorderableListTileState();
}

class _ReorderableListTileState extends State<ReorderableListTile> {
  List<String> todoItems = ['Task 1', 'Task 2', 'Task 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reorderable List'),
      ),
      body: ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = todoItems.removeAt(oldIndex);
            todoItems.insert(newIndex, item);
          });
        },
        children: [
          for (int index = 0; index < todoItems.length; index++)
            ListTile(
              key: Key('$index'), // Provide a unique key for each item
              tileColor: Colors.blue[100],
              title: Text(todoItems[index]),
            ),
        ],
      ),
    );
  }
}
