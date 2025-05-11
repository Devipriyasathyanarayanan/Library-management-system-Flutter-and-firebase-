import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class ProfilePage extends StatefulWidget {
  final String regNo;

  ProfilePage({required this.regNo});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> userDetails = {};
  List<Map<String, dynamic>> issuedBooks = [];

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchIssuedBooks();
  }

  void fetchUserDetails() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.regNo).get();
      if (userDoc.exists) {
        setState(() {
          userDetails = userDoc.data() as Map<String, dynamic>;
        });
        print("User Details Fetched: $userDetails"); // Debug print
      } else {
        print("User not found in Firestore"); // Debug print
      }
    } catch (e) {
      print("Error fetching user details: $e"); // Debug print
    }
  }

  void fetchIssuedBooks() async {
    try {
      QuerySnapshot booksSnapshot = await _firestore
          .collection('IssuedBooks')
          .where('regno', isEqualTo: widget.regNo)
          .get();
      if (booksSnapshot.docs.isNotEmpty) {
        setState(() {
          issuedBooks = booksSnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Convert Timestamp to String for issueDate and returnDate
            if (data['issueDate'] != null) {
              data['issueDate'] = _formatDate(data['issueDate']);
            }
            if (data['returnDate'] != null) {
              data['returnDate'] = _formatDate(data['returnDate']);
            }
            return data;
          }).toList();
        });
        print("Issued Books Fetched: $issuedBooks"); // Debug print
      } else {
        print("No issued books found for this user"); // Debug print
      }
    } catch (e) {
      print("Error fetching issued books: $e"); // Debug print
    }
  }

  // Helper function to format Timestamp to String
  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Convert Timestamp to DateTime
    return DateFormat('yyyy-MM-dd').format(date); // Format DateTime to String
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image Covering the Entire Page
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/dept_Z.jpeg'), // Replace with your image path
                fit: BoxFit.cover, // Cover the entire page
              ),
            ),
          ),
          // Dark Overlay for Better Readability
          Container(
            color: Colors.black.withOpacity(0.3), // Adjust opacity for better readability
          ),
          // Scrollable Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  // Circular Icon with Image
                  CircleAvatar(
                    radius: 60, // Increased size
                    backgroundImage: AssetImage('images/profile_icon.png'), // Replace with your icon path
                  ),
                  SizedBox(height: 20),
                  // User Details with Shadow
                  Text(
                    userDetails['name'] ?? 'NA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Reg No: ${userDetails['regno'] ?? 'NA'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Email: ${userDetails['email'] ?? 'NA'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Department: ${userDetails['department'] ?? 'NA'}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Books Table
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2), // Transparent container
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DataTable(
                      columnSpacing: 12, // Adjust spacing between columns
                      dataRowHeight: 48, // Adjust row height
                      headingRowColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.green; // Green background for table headers
                        },
                      ),
                      columns: [
                        DataColumn(
                            label: Text('Book Name',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Author',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Book ID',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Issue Date',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Return Date',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Fine Amount',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                      rows: issuedBooks.isEmpty
                          ? [
                              DataRow(cells: [
                                DataCell(Text('NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text('NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text('NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text('NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text('NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text('NA',
                                    style: TextStyle(color: Colors.white))),
                              ])]
                          : issuedBooks.map((book) {
                              return DataRow(cells: [
                                DataCell(Text(book['bookTitle'] ?? 'NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text(book['author'] ?? 'NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text(book['bookId'] ?? 'NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text(book['issueDate'] ?? 'NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text(book['returnDate'] ?? 'NA',
                                    style: TextStyle(color: Colors.white))),
                                DataCell(Text(book['fine']?.toString() ?? 'NA',
                                    style: TextStyle(color: Colors.white))),
                              ]);
                            }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}