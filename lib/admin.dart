import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'add_book.dart';
import 'edit_book.dart';
import 'remove_book.dart';
import 'new_user.dart';
import 'edit_user.dart';
import 'delete_user.dart';
import 'issue.dart';
import 'notification_admin.dart';
import 'aboutadmin.dart';
import 'bookadmin.dart';
import 'eventa.dart';
import 'eventadmin.dart';
import 'report.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String? selectedCard;

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
        automaticallyImplyLeading: false, // Remove the back button
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
                      'images/dept_Z.jpeg', //  your image path
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
              _logout(context); // Logout functionality
            },
            icon: Icon(Icons.admin_panel_settings, color: Colors.white),
            label: Text(
              "Admin",
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

  void _logout(BuildContext context) {
    // Navigate to the home page
    Navigator.pushReplacementNamed(context, '/home');
    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Admin logged out successfully!"),
        backgroundColor: Colors.green,
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
            _buildCardGrid(),
            SizedBox(height: 20),
            _buildContactDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 50,
      mainAxisSpacing: 50,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildCard(
            'Book Management', Icons.book, Colors.lightBlue, '/bookManagement'),
        _buildCard('User Management', Icons.person, Colors.orangeAccent,
            '/userManagement'),
        _buildCard('Reports', Icons.bar_chart, Colors.purpleAccent, '/reports'),
        _buildCard('Return/Issue', Icons.assignment_return, Colors.teal,
            '/ReturnIssuePage'), // This is the card for Return/Issue
        _buildCard('Event Updates', Icons.event, Colors.pink, '/eventUpdates'),
        _buildCard('Notifications', Icons.notifications, Colors.amber,
            '/notifications'),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, Color bgColor, String route) {
    bool isSelected = selectedCard == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCard = title;
        });

        if (title == 'Book Management') {
          _showBookManagementDialog(context);
        } else if (title == 'User Management') {
          _showUserManagementDialog(context);
        } else if (title == 'Return/Issue') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReturnIssuePage()),
          );
        } else if (title == 'Notifications') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
        } else if (title == 'Event Updates') {
          // Navigate to EventAdminPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AdminUpdateEventPage()),
          );
        } else if (title == 'Reports') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ReportsPage()),
          );
        }  else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? bgColor.withOpacity(0.7) : bgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 100, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Transparent background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Book Management',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.add,
                  title: 'Add Book',
                  color: Colors.blue.withOpacity(0.8),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddBookPage()),
                    );
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.edit,
                  title: 'Edit Book',
                  color: Colors.orange.withOpacity(0.8),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditBookPage()),
                    );
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.delete,
                  title: 'Delete Book',
                  color: Colors.red.withOpacity(0.8),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RemoveBookPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUserManagementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Transparent background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'User Management',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.person_add,
                  title: 'Add User',
                  color: Colors.green.withOpacity(0.8),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewUserPage()),
                    );
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.edit,
                  title: 'Edit User',
                  color: Colors.blue.withOpacity(0.8),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditUserPage()),
                    );
                  },
                ),
                _buildDialogOption(
                  context,
                  icon: Icons.delete,
                  title: 'Remove User',
                  color: Colors.red.withOpacity(0.8),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RemoveUserPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogOption(BuildContext context,
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: 16), // Adjusted padding for bigger height
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40), // Increased icon size
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24, // Increased font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
      _buildNavItem(Icons.home, 'Home', context, AdminHomePage()),
      _buildNavItem(Icons.info, 'About Us', context, Aboutadminpage()),
      _buildNavItem(Icons.book, 'Book Details', context, BooksadminPage()),
      _buildNavItem(Icons.event, 'Event Updates', context, EventadminPage()),
    ],
  );
}

 Widget _buildNavItem(
    IconData icon, String title, BuildContext context, Widget page) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    onTap: () {
      if (title == 'Log Out') {
        _logout(context); // Call logout function
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }
    },
  );
}
}