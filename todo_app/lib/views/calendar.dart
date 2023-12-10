/// Calendar View for Requirement number 6 stuctured this project as MVC
// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/controllers/calendar_controller.dart';
import 'package:todo_app/models/events.dart';

class CalendarView extends StatefulWidget {
  
  //Constructor the calendarview to connect with controller
  final CalendarController controller;
  const CalendarView({Key? key, required this.controller}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  
  //Controller for text editing for Create and Update function
  final TextEditingController _eventController = TextEditingController();

  //Contrustor for _isloading
  bool _isLoading = true;

  //To initiliaze the data for the event
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

//Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farhan's Assessment"),
        centerTitle: true,
      ),
      floatingActionButton: _fab(),
      body: _body(),
    );
  }

///Where I implement the logic for Requirement 1D, Transition of the page as when loading or no data
  Widget _body() {
    return Column(
      children: [
        _tableCalendar(),
        SizedBox(height: 20),
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

///Requirement for 1B, Calendar view 
///Requirement for number 3, To-do item is able to add into calendar events.
  Widget _tableCalendar() {
    return TableCalendar(
      //The current day
      focusedDay: widget.controller.selectedDay,

      //Caledar format
      firstDay: DateTime(2000),
      lastDay: DateTime(2030),
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekVisible: true,
      calendarFormat: widget.controller.format,
      onFormatChanged: (CalendarFormat _format) {
        setState(() {
          widget.controller.format = _format;
        });
      },

      //Calendar Style
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Colors.blue[300],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5.0),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
          )),
      
      //Calendar when selected a day
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          widget.controller.selectedDay = selectDay;
          widget.controller.focusedDay = focusDay;
        });
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(widget.controller.selectedDay, date);
      },

      //Where I Implement the getEventFromDay from Calendar Controller
      eventLoader: widget.controller.getEventsFromDay,
    );
  }

///Requirement for 1D, the no data page
  Widget _emptyState() {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 20),
          Icon(Icons.calendar_month_outlined, size: 50),
          SizedBox(height: 15),
          Text("No events for selected day!", style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),),
        ],
      ),
    );
  }

///Requirement for 1D, loading state
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

///Requirement for number 1C, 2 and 5
  Widget _eventList() {
    return Expanded(
      //Reorder widget for requirement 1C and uses controller to pass the function
      child: ReorderableListView(
        padding: EdgeInsets.only(right: 20),
        onReorder: (oldIndex, newIndex) {
          widget.controller.reorderEvents(oldIndex, newIndex);
          setState(() {});
        },
       
       //Requirement 5 where it need to show persist data from controller
        children: widget.controller
            .getEventsFromDay(widget.controller.selectedDay)
            .asMap()
            .entries
            .map(
              (entry) => Container(
                key: ValueKey(entry.key),
                margin: EdgeInsets.fromLTRB(20, 5, 0, 5),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Complete todo item for Requirement number 2
                      Checkbox(
                        value: entry.value.isDone,
                        onChanged: (value) {
                          widget.controller.toggleDone(entry.value);
                          setState(() {});
                        },
                      ),
                      //Edit todo item for Requirement number 2
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editEvent(entry.value);
                        },
                      ),
                      //Delete todo item for Requirement number 2
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

//FAB for requirement 2, add data into list and requirement 3, to add it into calendar event
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

///
///
/// function
///
///

 //delete function
  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Are you sure you want to delete this event?"),
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

//delete function
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
