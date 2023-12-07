
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:todo_app/views/calendar.dart';
import 'package:todo_app/views/calendar_view.dart';
import 'package:todo_app/views/widgets/reorder_listtile.dart';
import 'views/guide_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),initialRoute: '/',
      routes: {
        '/': (context) => GuidePage(),
        '/calendar': (context) => CalendarView(),
        '/test': (context) => Calendar(),
        '/list': (content) => ReorderableListTile()
      },
    );
  }
}
