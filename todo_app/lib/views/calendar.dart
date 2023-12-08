// calendar.dart
// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/controllers/calendar_controller.dart';
import 'package:todo_app/models/events.dart';

class CalendarView extends StatefulWidget {
  final CalendarController controller;

  const CalendarView({Key? key, required this.controller}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final TextEditingController _eventController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    widget.controller.selectedEvents = {};
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App Calendar"),
        centerTitle: true,
      ),
      floatingActionButton: _fab(),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _tableCalendar(),
        _isLoading
            ? _buildLoadingState()
            : widget.controller
                    .getEventsFromDay(widget.controller.selectedDay)
                    .isEmpty
                ? _emptyState()
                : _eventList(),
      ],
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: widget.controller.selectedDay,
      firstDay: DateTime(1990),
      lastDay: DateTime(2050),
      calendarFormat: widget.controller.format,
      onFormatChanged: (CalendarFormat _format) {
        setState(() {
          widget.controller.format = _format;
        });
      },
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekVisible: true,
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          widget.controller.selectedDay = selectDay;
          widget.controller.focusedDay = focusDay;
        });
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(widget.controller.selectedDay, date);
      },
      eventLoader: widget.controller.getEventsFromDay,
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        children: const [
          Icon(Icons.calendar_month_outlined, size: 100),
          Text("No events for selected day!"),
        ],
      ),
    );
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
          widget.controller.reorderEvents(oldIndex, newIndex);
          setState(() {});
        },
        children: widget.controller
            .getEventsFromDay(widget.controller.selectedDay)
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
                          widget.controller.toggleDone(entry.value);
                          setState(() {});
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
                          _deleteEvent(entry.value);
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
                  // Handle empty event title
                } else {
                  widget.controller.addEvent(_eventController.text);
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

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete $event"),
        actions: [
          TextButton(
            child: Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              widget.controller.removeEvent(event);
              Navigator.pop(context);
              setState(() {});
            },
          ),
        ],
      ),
    );
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
                widget.controller.editEvent(event, _eventController.text);
              }
              Navigator.pop(context);
              _eventController.clear();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
