import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'booklogin.dart';
import 'homepage.dart';
import 'eventlogin.dart';

class Aboutloginpage extends StatelessWidget {
  const Aboutloginpage({super.key});

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
                            AboutUsPage(),
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
                      AboutUsPage(),
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

  Widget _buildWelcomeText(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(10.0),
    color: Color.fromARGB(255, 62, 98, 62)
        .withOpacity(0.7), // Semi-transparent background
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // Center the text
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
        // Removed the ElevatedButton.icon widget
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
        _buildNavItem(Icons.home, 'Home', context, HomePageAfterLogin(regNo:'')),
        _buildNavItem(Icons.info, 'About Us', context, Aboutloginpage()),
        _buildNavItem(Icons.book, 'Book Details', context, BooksloginPage()),
        _buildNavItem(Icons.event, 'Event Updates', context, EventloginPage()),
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
}

class AboutUsPage extends StatelessWidget {
  final List<Map<String, String>> sections = [
    {"title": "About Us", "content": "Welcome to BookEase, your go-to app for managing all things related to computer science books and resources. Whether you’re a student, researcher, or professional, we provide a seamless platform for discovering, borrowing, and managing books that enhance your learning and expertise in the tech world.", "image": "images/about us.png"},
    {"title": "Our Vision", "content": "At BookEase, we aim to simplify the process of accessing computer science literature and educational resources. Our vision is to create a hassle-free environment where users can easily find, borrow, and organize their favorite books, from algorithms and programming to machine learning and software development.", "image": "images/our vision 1.webp"},
    {"title": "What We Offer", "content": "Our app offers a simple, efficient interface for managing a curated collection of computer science books, covering topics like programming, data structures, algorithms, and Web designing. Enjoy an easy and organized process for borrowing, and returning your books. BookEase is tailored to your interests in tech, making it the perfect companion for your academic or professional journey.", "image": "images/what we offer.webp"},
    {"title": "Our Commitment", "content": "We are dedicated to providing an intuitive and comprehensive library management experience. By focusing exclusively on computer science resources, we aim to foster an environment where learning and development in the tech field can thrive.", "image": "images/our commitment.webp"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.7), // Semi-transparent background
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(sections.length, (index) {
          bool isLeftAligned = index % 2 == 0;
          return Column(
            children: [
              Row(
                children: [
                  if (!isLeftAligned)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(sections[index]['image']!, height: 250, fit: BoxFit.cover),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sections[index]['title']!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 62, 98, 62),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            sections[index]['content']!,
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLeftAligned)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(sections[index]['image']!, height: 250, fit: BoxFit.cover),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }
}