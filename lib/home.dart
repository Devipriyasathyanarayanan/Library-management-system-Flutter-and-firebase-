import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login.dart';
import 'about.dart';
import 'book.dart';
import 'event.dart';
import 'books_layout.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(Icons.login, color: Colors.white),
          label: Text(
            "Login / Signup",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width < 600 ? 10 : 20,
              vertical: 10,
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
          _buildBannerSection(context),
          SizedBox(height: 20),
          _buildCategorySection(context),
          SizedBox(height: 30),
          _buildContactDetails(),
        ],
      ),
    ),
  );
}

Widget _buildBannerSection(BuildContext context) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.width < 600 ? 250 : 350,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.7), // Semi-transparent background
      border: Border.all(color: Colors.white, width: 4),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 4,
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover to Deliver",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 24 : 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.book, color: Colors.black, size: 30),
                  SizedBox(width: 10),
                  Icon(Icons.computer, color: Colors.black, size: 30),
                  SizedBox(width: 10),
                  Icon(Icons.school, color: Colors.black, size: 30),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Explore the world of knowledge and innovation with StudyArc Library.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 14 : 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        if (MediaQuery.of(context).size.width > 600)
          Image.asset(
            'images/bannerimg.png',
            width: 600,
            height: 400,
            fit: BoxFit.fill,
          ),
      ],
    ),
  );
}

Widget _buildCategorySection(BuildContext context) {
  final categories = [
    {
      "title": "C Programming",
      "color": Colors.blue,
      "image": 'images/c_programming.jpg'
    },
    {
      "title": "C++ Programming",
      "color": Colors.green,
      "image": 'images/cpp_programming.jpg'
    },
    {"title": "Python Programming", 
    "color": Colors.purple, 
    "image": 'images/python.jpg'
    },
    {
      "title": ".Net Technologies",
      "color": Colors.orange,
      "image": 'images/net.jpg'
    },
    {
      "title": "Computer Architecture",
      "color": Colors.red,
      "image": 'images/computer_architecture.jpg'
    },
    {
      "title": "Software Engineering",
      "color": Colors.teal,
      "image": 'images/software_eng.jpg'
    },
    {
      "title": "Operating Systems",
      "color": Colors.orange,
      "image": 'images/os.jpeg'
    },
    {
      "title": "DBMS",
      "color": Colors.blue,
      "image": 'images/dbms.jpg'
    },
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Categories",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 10),
      Container(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(
              context, // Pass context here
              categories[index]["title"] as String,
              categories[index]["color"] as Color,
              categories[index]["image"] as String,
            );
          },
        ),
      ),
      SizedBox(height: 10),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to BooksPage when "See More" is clicked
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BooksPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            "See More",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    ],
  );
}
Widget _buildCategoryCard(
    BuildContext context, String category, Color color, String imagePath) {
  return GestureDetector(
    onTap: () {
      // Navigate to BooksLayout with the selected category
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BooksLayout(category: category),
        ),
      );
    },
    child: Container(
      height: 150,
      width: 200,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 2),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              category,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
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