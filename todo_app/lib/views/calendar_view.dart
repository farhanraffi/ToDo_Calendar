// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/controllers/todo_controller.dart';
import 'package:todo_app/models/todo_model.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  List<String> todoItems = ['Task 1', 'Task 2', 'Task 3'];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<TodoModel>> todo = {
    DateTime.now(): [
      TodoModel(title: 'Task 1'),
      TodoModel(title: 'Task 2'),
    ],
    DateTime.now().add(Duration(days: 1)): [
      TodoModel(title: 'Task 3'),
      TodoModel(title: 'Task 4'),
    ],
    DateTime.now().add(Duration(days: 2)): [
      TodoModel(title: 'Task 5'),
    ],
  };

  final TodoController _todoController = TodoController();
  final TextEditingController _textEditingController = TextEditingController();

  late final ValueNotifier<List<TodoModel>> _selectedTodo;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedTodo = ValueNotifier(_getTodoForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTodo.value = _getTodoForDay(selectedDay);
      });
    }
  }

  List<TodoModel> _getTodoForDay(DateTime day) {
    return todo[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar View'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add Todo for date\n"),
                  content: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          controller: _textEditingController,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          _button();
                        },
                        child: Text("submit"))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,
            eventLoader: _getTodoForDay,
            calendarStyle: CalendarStyle(outsideDaysVisible: false),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<TodoModel>>(
                valueListenable: _selectedTodo,
                builder: (context, value, _) {
                  return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            onTap: () {},
                            title: Text('${value[index].title}'),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  _reorderlist() {
    return ReorderableListView(
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
    );
  }

  void _button() {
    todo.addAll({
      _selectedDay!: [TodoModel(title: _textEditingController.text)]
    });
    Navigator.of(context).pop();
    _selectedTodo.value = _getTodoForDay(_selectedDay!);
    _textEditingController.clear();
  }
}
