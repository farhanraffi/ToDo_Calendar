// calendar_controller.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/events.dart';

class CalendarController {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  CalendarController() {
    selectedEvents = {};
  }

  List<Event> getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void removeEvent(Event event) {
    selectedEvents[selectedDay]?.remove(event);
  }

  void editEvent(Event event, String newTitle) {
    event.title = newTitle;
  }

  void reorderEvents(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = getEventsFromDay(selectedDay).removeAt(oldIndex);
    getEventsFromDay(selectedDay).insert(newIndex, item);
  }

  void toggleDone(Event event) {
    event.isDone = !event.isDone;
  }

  void addEvent(String title) {
    if (title.isNotEmpty) {
      if (selectedEvents[selectedDay] != null) {
        selectedEvents[selectedDay]!.add(
          Event(title: title),
        );
      } else {
        selectedEvents[selectedDay] = [
          Event(title: title),
        ];
      }
    }
  }
}
