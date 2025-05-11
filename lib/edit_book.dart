import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookPage extends StatefulWidget {
  const EditBookPage({Key? key}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _bookExists = false; // Flag to check if book exists

  // Fetch book details when Book ID is entered
  void _fetchBookDetails() async {
    String bookId = _bookIdController.text.trim();
    if (bookId.isEmpty) return;

    final docRef = _firestore.collection('LibraryBooks').doc(bookId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      setState(() {
        _bookExists = true;
        _bookTitleController.text = docSnapshot['title'];
        _authorController.text = docSnapshot['author'];
        _categoryController.text = docSnapshot['category'];
      });
    } else {
      setState(() {
        _bookExists = false;
        _bookTitleController.clear();
        _authorController.clear();
        _categoryController.clear();
      });
      _showErrorMessage("Book ID does not exist!");
    }
  }

  // Update only modified fields in Firestore
  void _updateBookDetails() async {
    if (_formKey.currentState!.validate()) {
      String bookId = _bookIdController.text.trim();
      final docRef = _firestore.collection('LibraryBooks').doc(bookId);

      Map<String, dynamic> updatedData = {};

      // Only update fields that have changed
      if (_bookTitleController.text.trim().isNotEmpty) {
        updatedData['title'] = _bookTitleController.text.trim();
      }
      if (_authorController.text.trim().isNotEmpty) {
        updatedData['author'] = _authorController.text.trim();
      }
      if (_categoryController.text.trim().isNotEmpty) {
        updatedData['category'] = _categoryController.text.trim();
      }

      if (updatedData.isNotEmpty) {
        try {
          await docRef.update(updatedData);
          _showSuccessMessage("Book updated successfully!");
        } catch (e) {
          _showErrorMessage("Update failed: $e");
        }
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
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
    Function(String)? onChanged,
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
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Book Details',
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
                        onChanged: (value) => _fetchBookDetails(),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _bookTitleController,
                        label: 'Book Title',
                        hint: 'Enter Book Title',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _authorController,
                        label: 'Author Name',
                        hint: 'Enter Author Name',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _categoryController,
                        label: 'Category',
                        hint: 'Enter Category',
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _bookExists ? _updateBookDetails : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            backgroundColor: _bookExists
                                ? Colors.blue.withOpacity(0.8)
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Update Book',
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