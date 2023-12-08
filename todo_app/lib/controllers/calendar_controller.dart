/// Calendar Controller for Requirement number 6 stuctured this project as MVC

//import for this file
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/events.dart';

class CalendarController {
  //Map for DateTime as the key and List of Event for the event for the day
  late Map<DateTime, List<Event>> selectedEvents;

  //Requirement for setting up the Table Calendar and Datetime format
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  //What will be return if using the CalendarContoller
  CalendarController() {
    selectedEvents = {};
  }

  ///CRUD for requirement number 2
  //Create event
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

  //Read all event from the List, using Date as the key to get the list
  List<Event> getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  //Update event using event as the key and newTitle as what it can change
  void editEvent(Event event, String newTitle) {
    event.title = newTitle;
  }

  //Delete function where it whenever the selectedEvent has List, can delete an event from the list
  void removeEvent(Event event) {
    selectedEvents[selectedDay]?.remove(event);
  }

  //Function that required to use ReorderList Widget that have been import in PubDev, it uses index of the list of the event
  void reorderEvents(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = getEventsFromDay(selectedDay).removeAt(oldIndex);
    getEventsFromDay(selectedDay).insert(newIndex, item);
  }

  //For is done toggle function
  void toggleDone(Event event) {
    event.isDone = !event.isDone;
  }
}
