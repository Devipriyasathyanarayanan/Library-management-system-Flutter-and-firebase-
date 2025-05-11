import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_1/home.dart';
import 'about.dart';
import 'book.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width < 800
          ? Drawer(
              child: Container(
                color: Colors.blueGrey[900],
                child: _buildSideNav(context),
              ),
            )
          : null,
      appBar: AppBar(
        title: Text(
          "CSC LEARNING HUB",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 62, 98, 62),
        leading: MediaQuery.of(context).size.width < 800
            ? Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              )
            : null,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return Stack(
              children: [
                // Background Image with Adjusted Opacity
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), // Adjust opacity here
                      BlendMode.darken,
                    ),
                    child: Image.asset(
                      'images/dept_Z.jpeg', // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Sidebar
                    Container(
                      width: 250,
                      color: Colors.blueGrey[900],
                      child: _buildSideNav(context),
                    ),
                    // Main Content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildHeader(context),
                            _buildWelcomeText(context),
                            _buildScrollableContent(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                // Background Image with Adjusted Opacity
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.0), // Adjust opacity here
                      BlendMode.darken,
                    ),
                    child: Image.asset(
                      'images/dept_Z.jpeg', // Replace with your image path
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(context),
                      _buildWelcomeText(context),
                      _buildScrollableContent(context),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.7), // Semi-transparent background
      padding: EdgeInsets.symmetric(
          vertical: 35.0), // Add vertical padding for more space
      height: 150, // Set a fixed height for the header container
      child: Stack(
        children: [
          // College Logo in the Right Corner (Maximized Size)
          Positioned(
            right: 20, // Adjust position to the right
            top: 0, // Adjust position from the top
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width < 600
                    ? 150
                    : 80, // Maximum width
                maxHeight: MediaQuery.of(context).size.width < 600
                    ? 150
                    : 80, // Maximum height
              ),
              child: Image.asset(
                'images/college_logo.png',
                fit: BoxFit
                    .contain, // Ensure the image fits within the constraints
              ),
            ),
          ),
          // CSC LEARNING HUB Heading in the Right Corner
          Align(
            alignment:
                Alignment.topRight, // Move heading to the top-right corner
            child: Padding(
              padding: EdgeInsets.only(
                  right: 30, top: 10), // Adjust padding for positioning
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.5, // Adjust width as needed
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 600
                        ? 28
                        : 50, // Adjust font size here
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cursive',
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        "CSC LEARNING HUB",
                        speed: Duration(milliseconds: 200), // Speed of typing
                        textStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 28
                              : 50, // Adjust font size here
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cursive',
                          color: Colors.black,
                        ),
                      ),
                    ],
                    repeatForever: false, // Animation runs only once
                    pause:
                        Duration(milliseconds: 1000), // Pause after animation
                    displayFullTextOnTap: true, // Show full text when tapped
                    stopPauseOnTap: false, // Stop pause when tapped
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildWelcomeText(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(10.0),
    color: Color.fromARGB(255, 62, 98, 62)
        .withOpacity(0.7), // Semi-transparent background
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            "Welcome to CSC LEARNING HUB!",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 600 ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildScrollableContent(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.7), // Semi-transparent background
      borderRadius: BorderRadius.circular(15),
    ),
    child: SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildEventContent(context),
          SizedBox(height: 30),
          _buildContactDetails(),
        ],
      ),
    ),
  );
}




Widget _buildContactDetails() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    color: Color.fromARGB(255, 62, 98, 62)
        .withOpacity(0.7), // Semi-transparent background
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "librarycsc25@gmail.com",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Women's Christian College,51 College Road,Chennai 600006",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "20275926/28276798",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(Icons.contact_mail, color: Colors.white, size: 50),
            SizedBox(height: 10),
            Text(
              "Reach out for more info!",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget _buildEventContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserEventPage(),
        ],
      ),
    );
  }
Widget _buildSideNav(BuildContext context) {
  return ListView(
    children: [
      DrawerHeader(
        decoration: BoxDecoration(color: Colors.blueGrey[900]),
        child: Image.asset('images/logo.png', width: 300, height: 125),
      ),
      _buildNavItem(Icons.home, 'Home', context, HomePage()),
      _buildNavItem(Icons.info, 'About Us', context, Aboutpage()),
      _buildNavItem(Icons.book, 'Book Details', context, BooksPage()),
      _buildNavItem(Icons.event, 'Event Updates', context, EventPage()),
    ],
  );
}

Widget _buildNavItem(
    IconData icon, String title, BuildContext context, Widget? page) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: TextStyle(color: Colors.white)),
    onTap: () {
      if (page != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }
    },
  );
}
class UserEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('events').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var events = snapshot.data!.docs;

        if (events.isEmpty) {
          return Center(child: Text("No events available."));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(12),
          itemCount: events.length,
          itemBuilder: (context, index) {
            var event = events[index];
            return Card(
              margin: EdgeInsets.only(bottom: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 10,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EVENT NAME: ${event['eventName']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 62, 98, 62)),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'EVENT DATE: ${event['eventDate']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 62, 98, 62)),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'EVENT DESCRIPTION:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 62, 98, 62)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      event['eventDescription'],
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}