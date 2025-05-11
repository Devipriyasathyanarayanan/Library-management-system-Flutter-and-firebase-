import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Dashboard'),
        backgroundColor: Color.fromARGB(255, 62, 98, 62),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Library Statistics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStatisticsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard('Total Users', _fetchTotalUsers()),
        _buildStatCard('Total Books', _fetchTotalBooks()),
        _buildStatCard('Books Issued', _fetchIssuedBooks()),
        _buildStatCard('Books Available', _fetchAvailableBooks()),
      ],
    );
  }

  Widget _buildStatCard(String title, Future<int> futureCount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            FutureBuilder<int>(
              future: futureCount,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    snapshot.data.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _fetchTotalUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.length;
  }

  Future<int> _fetchTotalBooks() async {
    final snapshot = await FirebaseFirestore.instance.collection('LibraryBooks').get();
    return snapshot.docs.length;
  }

  Future<int> _fetchIssuedBooks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('IssuedBooks')
        .where('status', isEqualTo: 'Issued')
        .get();
    return snapshot.docs.length;
  }

  Future<int> _fetchAvailableBooks() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('LibraryBooks')
        .where('status', isEqualTo: 'Available')
        .get();
    return snapshot.docs.length;
  }
}