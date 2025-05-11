import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveBookPage extends StatefulWidget {
  const RemoveBookPage({Key? key}) : super(key: key);

  @override
  _RemoveBookPageState createState() => _RemoveBookPageState();
}

class _RemoveBookPageState extends State<RemoveBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookIdController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to remove a book from Firestore
  void _removeBookFromFirestore() async {
    if (_formKey.currentState!.validate()) {
      String bookId = _bookIdController.text.trim();
      final docRef = _firestore.collection('LibraryBooks').doc(bookId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        try {
          await docRef.delete();
          _showSuccessMessage("Book removed successfully!");
          _clearFields();
        } catch (e) {
          _showErrorMessage("Failed to remove book: $e");
        }
      } else {
        _showErrorMessage("Book ID does not exist!");
      }
    }
  }

  void _clearFields() {
    _bookIdController.clear();
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) =>
              value!.isEmpty ? "Please enter $label" : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Remove Book',
          style: TextStyle(
              fontFamily: 'Times New Roman', fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image with ColorFilter
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
              child: Image.asset(
                'images/dept_Z.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          'images/logo.png',
                          height: 120,
                          width: 250,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _bookIdController,
                        label: 'Book ID',
                        hint: 'Enter Book ID',
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _removeBookFromFirestore,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            backgroundColor: Colors.red.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Remove Book',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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