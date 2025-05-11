import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _tomorrowReturns = [];
  List<Map<String, dynamic>> _todayReturns = [];
  List<Map<String, dynamic>> _notYetReturned = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    // Fetch issued books
    final snapshot = await _firestore.collection('IssuedBooks').get();
    final allBooks = snapshot.docs.map((doc) => doc.data()).toList();

    setState(() {
      _tomorrowReturns = allBooks.where((book) {
        final returnDate = book['returnDate'].toDate();
        return returnDate.year == tomorrow.year &&
            returnDate.month == tomorrow.month &&
            returnDate.day == tomorrow.day;
      }).toList();

      _todayReturns = allBooks.where((book) {
        final returnDate = book['returnDate'].toDate();
        return returnDate.year == now.year &&
            returnDate.month == now.month &&
            returnDate.day == now.day;
      }).toList();

      _notYetReturned = allBooks.where((book) {
        final returnDate = book['returnDate'].toDate();
        return returnDate.isBefore(now);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // Remove shadow
      ),
      body: Stack(
        children: [
          // Background Image with ColorFilter
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
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), // Transparent container
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

                    // Notification Sections
                    _buildSection('Tomorrow Returns', _tomorrowReturns),
                    const SizedBox(height: 20),
                    _buildSection('Today Returns', _todayReturns),
                    const SizedBox(height: 20),
                    _buildSection('Not Yet Returned', _notYetReturned),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        books.isEmpty
            ? const Text(
                'No data found',
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            : _buildNotificationTable(books),
      ],
    );
  }

  Widget _buildNotificationTable(List<Map<String, dynamic>> books) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Book ID', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Book Title', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('User Name', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Reg No', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Issue Date', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Return Date', style: TextStyle(color: Colors.white))),
        DataColumn(label: Text('Status', style: TextStyle(color: Colors.white))),
      ],
      rows: books.map((book) {
        final returnDate = book['returnDate'].toDate();
        final now = DateTime.now();

        // Add one day to the return date to start calculating fines from the next day
        final fineStartDate = returnDate.add(Duration(days: 1));

        // Check if the current date is after the fine start date
        final isOverdue = now.isAfter(fineStartDate);

        return DataRow(
          color: MaterialStateProperty.resolveWith<Color>(
            (states) => isOverdue
                ? Colors.red.withOpacity(0.7) // Vibrant red for overdue rows
                : Colors.green.withOpacity(0.3), // Light green for other rows
          ),
          cells: [
            DataCell(Text(book['bookId'] ?? 'N/A', style: TextStyle(color: Colors.white))),
            DataCell(Text(book['bookTitle'] ?? 'N/A', style: TextStyle(color: Colors.white))),
            DataCell(Text(book['userName'] ?? 'Unknown', style: TextStyle(color: Colors.white))),
            DataCell(Text(book['regno'] ?? 'N/A', style: TextStyle(color: Colors.white))),
            DataCell(Text(DateFormat('dd/MM/yyyy').format(book['issueDate'].toDate()), style: TextStyle(color: Colors.white))),
            DataCell(Text(DateFormat('dd/MM/yyyy').format(returnDate), style: TextStyle(color: Colors.white))),
            DataCell(
              Text(
                isOverdue ? 'Overdue' : 'Due',
                style: TextStyle(
                  color: isOverdue ? Colors.white : Colors.black, // White text for overdue, black for others
                  fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}