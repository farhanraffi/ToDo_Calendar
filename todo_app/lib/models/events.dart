/// Event Model for Requirement number 6 stuctured this project as MVC
//Model for the event, it have title, and isDone
class Event {
  String title;
  bool isDone;

  Event({required this.title, this.isDone = false});
}
