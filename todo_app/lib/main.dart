// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api


//Import for MyApp and HomePage
import 'package:flutter/material.dart';
import 'package:todo_app/controllers/calendar_controller.dart';
import 'package:todo_app/views/calendar.dart';
import 'views/guide_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vimigo Assement',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //_calendarController as it required param when doing the routing
  late CalendarController _calendarController;

  //initState for initiliazting the controller
  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //Turning off debug banner in the application
      debugShowCheckedModeBanner: false,

      //The title of the application
      title: 'ToDo App',

      //Theme of the application, using blue bacis color for Flutter
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      //route when first time opening the application
      initialRoute: '/',

      //List of route for every view page in the application
      routes: {
        '/': (context) => GuidePage(),
        '/calendar': (context) => CalendarView(controller: _calendarController)
      },
    );
  }
}
