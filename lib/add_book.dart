import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart' as excel; // Add prefix to avoid conflicts
import 'dart:io';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookIdController = TextEditingController();
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'C Programming', 'C++ Programming', 'Java Programming', 'Computer Architecture', 'DBMS',
    'Web Technologies', 'Information Tech', 'Algorithms', 'Networks & Cyber Security', 'E-Commerce',
    'Graphics & Multimedia', '.Net Technologies', 'Operating Systems', 'Python Programming', 'Research Papers',
    'Software Engineering', 'Data Structures & Algorithms', 'Digital, Electonics & Microprossors', 'PC Software - MS Office',
    'Trends in Computing', 'Linux & Unix', 'Environmental Studies', 'General Computer Science', 'Mathematics', 'Fist'
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addBookToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final docRef = _firestore.collection('LibraryBooks').doc(_bookIdController.text.trim());

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        _showErrorMessage("Book ID already exists! Use a different ID.");
      } else {
        try {
          await docRef.set({
            'bookId': _bookIdController.text.trim(),
            'title': _bookTitleController.text.trim(),
            'author': _authorController.text.trim(),
            'category': _selectedCategory,
            'status': 'Available', // Add default status
            'timestamp': FieldValue.serverTimestamp(),
          });

          _showSuccessMessage('Book added successfully!');
          _clearFields();
        } catch (e) {
          _showErrorMessage("Failed to add book: $e");
        }
      }
    }
  }

  void _uploadExcelSheet() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        // Use `bytes` instead of `path` for web compatibility
        var bytes = file.bytes;

        if (bytes != null) {
          var excelFile = excel.Excel.decodeBytes(bytes); // Use prefixed name

          int totalBooks = 0;
          int uploadedBooks = 0;

          for (var table in excelFile.tables.keys) {
            for (var row in excelFile.tables[table]!.rows) {
              if (row[0]?.value.toString() != 'Book ID') { // Skip header row
                totalBooks++;
                String bookId = row[0]?.value.toString() ?? '';
                String bookTitle = row[1]?.value.toString() ?? '';
                String authorName = row[2]?.value.toString() ?? '';
                String category = row[3]?.value.toString() ?? '';

                if (bookId.isNotEmpty && bookTitle.isNotEmpty && authorName.isNotEmpty && category.isNotEmpty) {
                  final docRef = _firestore.collection('LibraryBooks').doc(bookId.trim());

                  final docSnapshot = await docRef.get();

                  if (!docSnapshot.exists) {
                    try {
                      await docRef.set({
                        'bookId': bookId.trim(),
                        'title': bookTitle.trim(),
                        'author': authorName.trim(),
                        'category': category,
                        'status': 'Available', // Add default status
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      uploadedBooks++;
                    } catch (e) {
                      _showErrorMessage("Failed to add book: $e");
                    }
                  }
                }
              }
            }
          }

          if (uploadedBooks > 0) {
            _showSuccessMessage('$uploadedBooks out of $totalBooks books uploaded successfully!');
          } else {
            _showErrorMessage('No new books were uploaded. All books already exist in the database.');
          }
        } else {
          _showErrorMessage("Failed to read the file.");
        }
      } else {
        _showErrorMessage("No file selected.");
      }
    } catch (e) {
      _showErrorMessage("Error uploading Excel file: $e");
    }
  }

  void _clearFields() {
    _bookIdController.clear();
    _bookTitleController.clear();
    _authorController.clear();
    setState(() {
      _selectedCategory = null;
    });
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

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category",
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            hint: Text(
              "Select Category",
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            dropdownColor: Colors.black.withOpacity(0.8),
            style: TextStyle(color: Colors.white),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            validator: (value) =>
                value == null ? "Please select a category" : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Book',
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
                      _buildCategoryDropdown(),
                      const SizedBox(height: 30),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _addBookToFirestore,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Add Book',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _uploadExcelSheet,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Upload Excel Sheet',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
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