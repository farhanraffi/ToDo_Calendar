// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/events.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool _isLoading = true;

  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    // Simulate data loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _removeEvent(Event event) {
    setState(() {
      selectedEvents[selectedDay]?.remove(event);
    });
  }

  void _editEvent(Event event) {
    _eventController.text = event.title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Event"),
        content: TextFormField(
          controller: _eventController,
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Save"),
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                setState(() {
                  event.title = _eventController.text;
                });
              }
              Navigator.pop(context);
              _eventController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _reorderEvents(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = _getEventsfromDay(selectedDay).removeAt(oldIndex);
      _getEventsfromDay(selectedDay).insert(newIndex, item);
    });
  }

  void _toggleDone(Event event) {
    setState(() {
      event.isDone = !event.isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("To Do App Calendar"),
          centerTitle: true,
        ),
        floatingActionButton: _fab(),
        body: _body());
  }

  Widget _body() {
    return Column(
      children: [
        _tableCalendar(),
        _isLoading
            ? _buildLoadingState()
            : _getEventsfromDay(selectedDay).isEmpty
                ? _emptyState()
                : _eventList(),
      ],
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: selectedDay,
      firstDay: DateTime(1990),
      lastDay: DateTime(2050),
      calendarFormat: format,
      onFormatChanged: (CalendarFormat _format) {
        setState(() {
          format = _format;
        });
      },
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekVisible: true,

      //Day Changed
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          selectedDay = selectDay;
          focusedDay = focusDay;
        });
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(selectedDay, date);
      },
      eventLoader: _getEventsfromDay,
    );
  }

  Widget _emptyState() {
    return Center(
        child: Column(
      children: const [
        Icon(Icons.calendar_month_outlined, size: 100),
        Text("No events for selected day!"),
      ],
    ));
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _eventList() {
    return Expanded(
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          _reorderEvents(oldIndex, newIndex);
        },
        children: _getEventsfromDay(selectedDay)
            .asMap()
            .entries
            .map(
              (entry) => Container(
                key: ValueKey(entry.key),
                margin: EdgeInsets.fromLTRB(15, 15, 0, 5),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: entry.value.isDone,
                        onChanged: (value) {
                          _toggleDone(entry.value);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editEvent(entry.value);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _removeEvent(entry.value);
                        },
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  title: Text(entry.value.title),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton.extended(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Add Event"),
          content: TextFormField(
            controller: _eventController,
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                if (_eventController.text.isEmpty) {
                } else {
                  if (selectedEvents[selectedDay] != null) {
                    selectedEvents[selectedDay]!.add(
                      Event(title: _eventController.text),
                    );
                  } else {
                    selectedEvents[selectedDay] = [
                      Event(title: _eventController.text)
                    ];
                  }
                }
                Navigator.pop(context);
                _eventController.clear();
                setState(() {});
                return;
              },
            ),
          ],
        ),
      ),
      label: Text("Add Event"),
      icon: Icon(Icons.add),
    );
  }
}
