import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_application_1/eventlogin.dart';
import 'aboutlogin.dart';
import 'eventlogin.dart';
import 'books_layout.dart';
import 'homepage.dart';

class BooksloginPage extends StatelessWidget {
  final String? category; // Add a category parameter

  const BooksloginPage({super.key, this.category}); // Update constructor

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
          category ?? "CSC LEARNING HUB", // Display the category name in the AppBar
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
                            _buildBookContent(context), // Updated to include book content
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
                      _buildBookContent(context), // Updated to include book content
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
          // Removed the Login/Signup Button
        ],
      ),
    );
  }

  Widget _buildBookContent(BuildContext context) {
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
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildCategoriesGrid(),
            SizedBox(height: 30),
            _buildContactDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: "Search Books",
          hintText: "Enter Category",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // 6 items per row
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1 / 1, // Adjust card size
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return BookCategoryBox(category: categories[index]);
      },
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

class BookCategoryBox extends StatelessWidget {
  final Category category;

  const BookCategoryBox({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BooksLayout(category: category.name),
          ),
        );
      },
      child: Card(
        color: Colors.green[200],
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  category.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final String imagePath;

  Category({required this.name, required this.imagePath});
}

final List<Category> categories = [
  Category(name: 'C Programming', imagePath: 'images/c_programming.jpg'),
  Category(name: 'C++ Programming', imagePath: 'images/cpp_programming.jpg'),
  Category(name: 'Java Programming', imagePath: 'images/java.jpg'),
  Category(name: 'Computer Architecture', imagePath: 'images/computer_architecture.jpg'),
  Category(name: 'DBMS', imagePath: 'images/dbms.jpg'),
  Category(name: 'Web Technologies', imagePath: 'images/web_tech.jpg'),
  Category(name: 'Information Tech', imagePath: 'images/it.jpg'),
  Category(name: 'Algorithms', imagePath: 'images/algorithms.jpg'),
  Category(name: 'Networks & Cyber Security', imagePath: 'images/cybersecurity.jpg'),
  Category(name: 'E-Commerce', imagePath: 'images/ecommerce.jpg'),
  Category(name: 'Graphics & Multimedia', imagePath: 'images/graphics.jpg'),
  Category(name: '.Net Technologies', imagePath: 'images/net.jpg'),
  Category(name: 'Operating Systems', imagePath: 'images/os.jpeg'),
  Category(name: 'Python Programming', imagePath: 'images/python.jpg'),
  Category(name: 'Research Papers', imagePath: 'images/research.jpg'),
  Category(name: 'Software Engineering', imagePath: 'images/software_eng.jpg'),
  Category(name: 'Data Structures & Algorithms', imagePath: 'images/dsa.jpg'),
  Category(name: 'Digital, Electronics & Microprocessors', imagePath: 'images/dem.jpg'),
  Category(name: 'PC Software - MS Office', imagePath: 'images/pc_software.jpg'),
  Category(name: 'Trends in Computing', imagePath: 'images/trends.jpg'),
  Category(name: 'Linux & Unix ', imagePath: 'images/linux.jpg'),
  Category(name: 'Environmental Studies ', imagePath: 'images/evs.jpg'),
  Category(name: 'General Computer Science', imagePath: 'images/General_cs.jpeg'),
  Category(name: 'Mathematics ', imagePath: 'images/maths.jpg'),
  Category(name: 'Fist', imagePath: 'images/fist.jpeg'),
];