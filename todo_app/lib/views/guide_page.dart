// ignore_for_file: import_of_legacy_library_into_null_safe, no_leading_underscores_for_local_identifiers
///Requirement number 4

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late VideoPlayerController _controller;

//popup initilizate
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/src/gif/tuto.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
    // Show the welcome popup when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomePopup();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            "Guide Page Carousel",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          //carousel widget
          _carousel(),
          SizedBox(height: 20),
          Text(
            "Guide Page Video",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          _video(),
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

  //video
  Widget _video() {
    return _controller.value.isInitialized
        ? Stack( alignment: AlignmentDirectional.center,
          children:[ Container(
            margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),IconButton(
              icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
            )
        ])
        : CircularProgressIndicator();
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

    // Function to load images asynchronously
    Future<String> _loadImage(String imageUrl) async {
      // Simulate a delay to demonstrate the loading indicator
      await Future.delayed(Duration(seconds: 2));
      return imageUrl;
    }

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
                    FutureBuilder(
                      // Use FutureBuilder to load images asynchronously
                      future: _loadImage(imageList[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show a loading indicator while the image is being loaded
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Handle errors
                          return Text('Error loading image');
                        } else {
                          // Show the image once it's loaded
                          return Image.network(
                            snapshot.data!,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                // Show a loading indicator while the image is being loaded
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      descriptions[index],
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w700),
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
}
