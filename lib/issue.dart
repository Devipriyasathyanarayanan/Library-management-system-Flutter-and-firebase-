import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:async'; // Import for Timer
import 'dart:ui'; // Import for ImageFilter

class ReturnIssuePage extends StatefulWidget {
  const ReturnIssuePage({Key? key}) : super(key: key);

  @override
  _ReturnIssuePageState createState() => _ReturnIssuePageState();
}

class _ReturnIssuePageState extends State<ReturnIssuePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Declare and initialize the missing variables
  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  DateTime? _issueDate;
  DateTime? _returnDate;
  List<Map<String, dynamic>> _issuedBooks = [];

  @override
  void initState() {
    super.initState();
    _startNotificationChecker(); // Start the notification checker
    _fetchIssuedBooks(); // Fetch issued books when the page loads
  }

  // Function to start the periodic notification checker
  void _startNotificationChecker() {
    Timer.periodic(Duration(hours: 24), (timer) {
      print('Checking for notifications...');
      _checkReturnDatesAndNotify();
    });
  }

  // Function to check return dates and send notifications
  Future<void> _checkReturnDatesAndNotify() async {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final issuedBooksSnapshot = await _firestore
        .collection('IssuedBooks')
        .where('status', isEqualTo: 'Issued')
        .get();

    print('Total issued books: ${issuedBooksSnapshot.docs.length}');

    for (var doc in issuedBooksSnapshot.docs) {
      final returnDate = doc['returnDate'].toDate();
      final userId = doc['userId'];
      final userSnapshot = await _firestore.collection('users').doc(userId).get();
      final userEmail = userSnapshot['email'];
      final bookTitle = doc['bookTitle'];

      print('Return Date: $returnDate');
      print('Now: $now');
      print('Difference: ${returnDate.difference(now).inDays}');

      if (isSameDay(returnDate, now)) {
        print('Return date is today for book: $bookTitle');
        await _sendEmailNotification(userEmail, 'Your book "$bookTitle" return date is today. Please return the book immediately.');
      } else if (returnDate.isAfter(now)) {
        final difference = returnDate.difference(now).inDays;

        if (difference == 1) {
          print('Return date is tomorrow for book: $bookTitle');
          await _sendEmailNotification(userEmail, 'Your book "$bookTitle" return date is tomorrow. Please return the book on time.');
        }
      } else if (returnDate.isBefore(now)) {
        print('Return date has passed for book: $bookTitle');
        await _sendEmailNotification(userEmail, 'Your book "$bookTitle" return date has passed. Please return the book as soon as possible.');
      }
    }

    setState(() => _isLoading = false);
  }

  // Helper function to check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Function to send email notifications
  Future<void> _sendEmailNotification(String email, String message) async {
    final smtpServer = gmail('librarycsc25@gmail.com', 'your-gmail-password'); // Replace with your Gmail credentials

    final emailMessage = Message()
      ..from = Address('librarycsc25@gmail.com', 'Library Management')
      ..recipients.add(email) // Replace with a hardcoded email for testing
      ..subject = 'Library Book Return Notification'
      ..text = message;

    try {
      print('Sending email to: $email');
      await send(emailMessage, smtpServer);
      print('Email sent successfully');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Issue/Return Book',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
      backgroundColor: Colors.white, // Transparent app bar
      elevation: 0, // Remove shadow
    ),
    body: Stack(
      children: [
        // Background Image with Adjusted Opacity
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), // Adjust opacity here
              BlendMode.darken,
            ),
            child: Image.asset(
              'images/dept_Z.jpeg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Blurred White Transparent Layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0), // Adjust blur intensity
            child: Container(
              color: Colors.white.withOpacity(0.3), // Adjust transparency here
            ),
          ),
        ),

        // Main Content
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Logo Image
              Center(
                child: Image.asset(
                  'images/logo.png', // Replace with your logo path
                  height: 120,
                  width: 250,
                ),
              ),
              const SizedBox(height: 20),

              // Book ID Field
              _buildTextField(
                controller: _bookIdController,
                label: 'Book ID',
                hint: 'Enter Book ID',
              ),
              const SizedBox(height: 20),

              // User ID Field
              _buildTextField(
                controller: _userIdController,
                label: 'User ID',
                hint: 'Enter User ID',
              ),
              const SizedBox(height: 20),

              // Issue Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _issueDate == null
                          ? 'Select Issue Date'
                          : 'Issue Date: ${DateFormat('dd/MM/yyyy').format(_issueDate!)}',
                      style: const TextStyle(fontSize: 16, color: Colors.black), // Changed to black for better visibility
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.black), // Changed to black for better visibility
                    onPressed: _pickIssueDate,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Issue Book Button
              ElevatedButton(
                onPressed: _issueBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.withOpacity(0.8), // Transparent button
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Issue Book', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 30),

              // Issued Books Table
              _issuedBooks.isEmpty
                  ? const Text('No data found', style: TextStyle(fontSize: 18, color: Colors.black)) // Changed to black for better visibility
                  : _buildIssuedBooksTable(),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white), // White text color
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2), // Transparent background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white), // White border
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // White hint text
            labelStyle: TextStyle(color: Colors.white), // White label text
          ),
          style: TextStyle(color: Colors.white), // White input text
        ),
      ],
    );
  }

  Future<void> _pickIssueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _issueDate = pickedDate;
        _returnDate = pickedDate.add(const Duration(days: 7)); // Auto-generate return date
      });
    }
  }

  Future<void> _issueBook() async {
    if (_bookIdController.text.isEmpty || _userIdController.text.isEmpty || _issueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select issue date'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Fetch Book Details
      final bookSnapshot = await _firestore.collection('LibraryBooks').doc(_bookIdController.text.trim()).get();
      if (!bookSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book not found'), backgroundColor: Colors.red),
        );
        return;
      }

      // Fetch User Details
      final userSnapshot = await _firestore.collection('users').doc(_userIdController.text.trim()).get();
      if (!userSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found'), backgroundColor: Colors.red),
        );
        return;
      }

      // Check if user has already issued 3 books
      final issuedBooksSnapshot = await _firestore
          .collection('IssuedBooks')
          .where('userId', isEqualTo: _userIdController.text.trim())
          .where('status', isEqualTo: 'Issued')
          .get();

      if (issuedBooksSnapshot.docs.length >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User has already issued 3 books'), backgroundColor: Colors.red),
        );
        return;
      }

      // Check if the book is already issued
      final bookIssuedSnapshot = await _firestore
          .collection('IssuedBooks')
          .where('bookId', isEqualTo: _bookIdController.text.trim())
          .where('status', isEqualTo: 'Issued')
          .get();

      if (bookIssuedSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book is already issued'), backgroundColor: Colors.red),
        );
        return;
      }

      // Add to IssuedBooks Collection
      await _firestore.collection('IssuedBooks').add({
        'bookId': _bookIdController.text.trim(),
        'bookTitle': bookSnapshot['title'],
        'userId': _userIdController.text.trim(),
        'userName': userSnapshot['name'] ?? 'Unknown', // Handle missing 'name' field
        'regno': userSnapshot['regno'] ?? 'N/A', // Handle missing 'regno' field
        'issueDate': _issueDate,
        'returnDate': _returnDate,
        'status': 'Issued',
        'fine': 0,
        'renewed': false,
      });

      // Update Book Status in LibraryBooks Collection
      await _firestore.collection('LibraryBooks').doc(_bookIdController.text.trim()).update({
        'status': 'Issued',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book issued successfully'), backgroundColor: Colors.green),
      );

      // Refresh Table
      _fetchIssuedBooks();
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchIssuedBooks() async {
    final snapshot = await _firestore.collection('IssuedBooks').get();
    setState(() {
      _issuedBooks = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _returnBook(String bookId, String userId) async {
    try {
      // Update Book Status to Available
      await _firestore.collection('LibraryBooks').doc(bookId).update({
        'status': 'Available',
      });

      // Delete the issued book record
      final issuedBookSnapshot = await _firestore
          .collection('IssuedBooks')
          .where('bookId', isEqualTo: bookId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'Issued')
          .get();

      for (var doc in issuedBookSnapshot.docs) {
        await _firestore.collection('IssuedBooks').doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book returned successfully'), backgroundColor: Colors.green),
      );

      // Refresh Table
      _fetchIssuedBooks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _renewBook(String bookId, String userId) async {
    try {
      // Fetch the issued book record
      final issuedBookSnapshot = await _firestore
          .collection('IssuedBooks')
          .where('bookId', isEqualTo: bookId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'Issued')
          .get();

      if (issuedBookSnapshot.docs.isNotEmpty) {
        final doc = issuedBookSnapshot.docs.first;
        final returnDate = doc['returnDate'].toDate();
        final renewed = doc['renewed'];

        if (renewed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Only one renewal is allowed'), backgroundColor: Colors.red),
          );
          return;
        }

        // Extend return date by 7 days
        final newReturnDate = returnDate.add(const Duration(days: 7));

        await _firestore.collection('IssuedBooks').doc(doc.id).update({
          'returnDate': newReturnDate,
          'renewed': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book renewed successfully'), backgroundColor: Colors.green),
        );

        // Refresh Table
        _fetchIssuedBooks();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildIssuedBooksTable() {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Book ID', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Book Title', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('User Name', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Reg No', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Issue Date', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Return Date', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Fine', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Status', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Return', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Renew', style: TextStyle(color: Colors.white))),
      ],
      rows: _issuedBooks.map((book) {
        final returnDate = book['returnDate'].toDate();
        final now = DateTime.now();

        // Add one day to the return date to start calculating fines from the next day
        final fineStartDate = returnDate.add(Duration(days: 1));

        // Check if the current date is after the fine start date
        final isOverdue = now.isAfter(fineStartDate);

        // Calculate fine only if the book is overdue
        final fine = isOverdue
            ? 5 + (now.difference(fineStartDate).inDays * 2) // Starts at ₹5 and increases by ₹2 per day
            : 0;

        final renewed = book['renewed'] ?? false;

        return DataRow(
          color: MaterialStateProperty.resolveWith<Color>(
            (states) => isOverdue ? Colors.red.withOpacity(0.7) : Colors.green.withOpacity(0.3),
          ),
          cells: [
            DataCell(Text(book['bookId'] ?? 'N/A', style: TextStyle(color: Colors.white))),
            DataCell(Text(book['bookTitle'] ?? 'N/A', style: TextStyle(color: Colors.white))),
            DataCell(Text(book['userName'] ?? 'Unknown', style: TextStyle(color: Colors.white))),
            DataCell(Text(book['regno'] ?? 'N/A', style: TextStyle(color: Colors.white))),
            DataCell(Text(DateFormat('dd/MM/yyyy').format(book['issueDate'].toDate()), style: TextStyle(color: Colors.white))),
            DataCell(Text(DateFormat('dd/MM/yyyy').format(returnDate), style: TextStyle(color: Colors.white))),
            DataCell(Text('₹$fine', style: TextStyle(color: Colors.white))),
            DataCell(Text(isOverdue ? 'Overdue' : 'Due', style: TextStyle(color: Colors.white))),
            DataCell(
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () => _returnBook(book['bookId'], book['userId']),
              ),
            ),
            DataCell(
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: renewed ? Colors.grey : Colors.blue, // Dynamic color based on 'renewed'
                ),
                onPressed: renewed
                    ? null
                    : () => _renewBook(book['bookId'], book['userId']),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _clearFields() {
    _bookIdController.clear();
    _userIdController.clear();
    setState(() {
      _issueDate = null;
      _returnDate = null;
    });
  }
}