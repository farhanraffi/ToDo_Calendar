// ignore_for_file: import_of_legacy_library_into_null_safe
///Requirement number 4

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  
//popup initilizate
  @override
  void initState() {
    super.initState();
    // Show the welcome popup when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomePopup();
    });
  }

//popup function
  void _showWelcomePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hi, Welcome to Guide Page!',
            textAlign: TextAlign.center,
          ),
          content: Text(
              'After finishing the carousel, you can continue to the real app!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Farhan's Assessment"),
          centerTitle: true,
        ),
        body: Center(child: _body()));
  }

  //Body
  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Guide Page",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          //carousel widget
          _carousel(),
          SizedBox(height: 20),
          _button(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  //button for next page
  Widget _button() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the next screen or close the guide
        Navigator.popAndPushNamed(context, '/calendar');
      },
      child: Text('Get Started'),
    );
  }
}

//carousel
Widget _carousel() {
  //List for image to put in carousel
  final List<String> imageList = [
    'lib/src/image/calendar.png',
    'lib/src/image/add.png',
    'lib/src/image/hasEvent.png',
    'lib/src/image/edit.png',
    'lib/src/image/reorder.png',
    'lib/src/image/delete.png',
    'lib/src/image/hasDone.png',
  ];

  //List of decription
  final List<String> descriptions = [
    'This is your calendar! It have no event for now!',
    'Clicking the "Add Event" will popup this dialog to add an event!',
    'The event can be edit, delete, and even reorder to your needs!',
    'Clicking the pensil icon will lead to this dialog to edit the event!',
    'You can also reorder the event by long hold the list icon!',
    'You can delete the event by clicking the bin icon!',
    'You can also click the checkbox to check the event!'
  ];

  return Container(
    padding: EdgeInsets.all(20),
    child: CarouselSlider.builder(
      options: CarouselOptions(
        height: 500.0,
        enlargeCenterPage: false,
        autoPlay: false,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
      itemCount: imageList.length,
      itemBuilder: (context, index, realIndex) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imageList[index],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    descriptions[index],
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
