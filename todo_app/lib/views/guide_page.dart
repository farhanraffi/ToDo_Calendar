import 'package:flutter/material.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Interactive Guide'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(
              'Welcome to ToDo App!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 20),
             Text(
              'Swipe right to see the calendar view',
              style: TextStyle(fontSize: 18),
            ),
             SizedBox(height: 10),
             Text(
              'Hold and drag to reorder your ToDo list',
              style: TextStyle(fontSize: 18),
            ),
             SizedBox(height: 10),
             Text(
              'Tap on a ToDo item to edit or complete it',
              style: TextStyle(fontSize: 18),
            ),
             SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the main app screen
                Navigator.pushReplacementNamed(context, '/calendar');
              },
              child:  Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
