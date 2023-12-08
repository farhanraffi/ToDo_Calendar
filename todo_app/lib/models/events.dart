// ignore_for_file: annotate_overrides, unnecessary_this

class Event {
  String title;
  bool isDone;

  Event({required this.title, this.isDone = false});

  String toString() => this.title;
}
