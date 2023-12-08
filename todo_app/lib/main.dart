// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:todo_app/controllers/calendar_controller.dart';
import 'package:todo_app/views/calendar.dart';
import 'package:todo_app/views/widgets/reorder_listtile.dart';
import 'views/guide_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calendar App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarController _calendarController;

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GuidePage(),
        '/calendar': (context) => CalendarView(controller: _calendarController),
        '/list': (content) => ReorderableListTile()
      },
    );
  }
}
