import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';

class NewUserPage extends StatefulWidget {
  const NewUserPage({Key? key}) : super(key: key);

  @override
  _NewUserPageState createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _regnoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); // Email ID field
  final TextEditingController _passwordController = TextEditingController(text: "Password@123"); // Default password
  String? _selectedDepartment; // Department dropdown value

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Email validation regex
  final _emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      final regno = _regnoController.text.trim();
      final email = _emailController.text.trim();

      // Validate email format
      if (!_emailRegex.hasMatch(email)) {
        _showErrorMessage("Please enter a valid email address.");
        return;
      }

      final docRef = _firestore.collection('users').doc(regno);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        _showErrorMessage("User already exists! Try a different Reg No.");
      } else {
        try {
          // Store the default password
          String password = _passwordController.text.trim();

          // Store user data in Firestore
          await docRef.set({
            'regno': regno,
            'name': _nameController.text.trim(),
            'email': email, // Store the email
            'password': password, // Store the default password
            'department': _selectedDepartment, // Store the selected department
            'first_login': true, // User will be required to change password on first login
          });

          _showSuccessMessage("User added successfully.");
          _clearFields();
        } catch (e) {
          _showErrorMessage("Failed to add user: $e");
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
          var excel = Excel.decodeBytes(bytes);

          int totalUsers = 0;
          int uploadedUsers = 0;

          for (var table in excel.tables.keys) {
            for (var row in excel.tables[table]!.rows) {
              if (row[0]?.value.toString() != 'Reg No') { // Skip header row
                totalUsers++;
                String regno = row[0]?.value.toString() ?? '';
                String name = row[1]?.value.toString() ?? '';
                String email = row[2]?.value.toString() ?? '';
                String department = row[3]?.value.toString() ?? '';

                if (regno.isNotEmpty && name.isNotEmpty && email.isNotEmpty && department.isNotEmpty) {
                  final docRef = _firestore.collection('users').doc(regno.trim());

                  final docSnapshot = await docRef.get();

                  if (!docSnapshot.exists) {
                    try {
                      await docRef.set({
                        'regno': regno.trim(),
                        'name': name.trim(),
                        'email': email.trim(),
                        'password': "Password@123", // Default password
                        'department': department,
                        'first_login': true, // User will be required to change password on first login
                      });
                      uploadedUsers++;
                    } catch (e) {
                      _showErrorMessage("Failed to add user: $e");
                    }
                  }
                }
              }
            }
          }

          if (uploadedUsers > 0) {
            _showSuccessMessage('$uploadedUsers out of $totalUsers users uploaded successfully!');
          } else {
            _showErrorMessage('No new users were uploaded. All users already exist in the database.');
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

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _clearFields() {
    _regnoController.clear();
    _nameController.clear();
    _emailController.clear();
    setState(() {
      _selectedDepartment = null; // Reset dropdown value
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool readOnly = false, // Add read-only option
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
          readOnly: readOnly, // Make field read-only if specified
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
          validator: (value) =>
              value!.isEmpty ? "Please enter $label" : null,
        ),
      ],
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white), // White text color
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                readOnly: true, // Make password field read-only
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2), // Transparent background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white), // White border
                  ),
                  hintText: 'Password is set automatically',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // White hint text
                  labelStyle: TextStyle(color: Colors.white), // White label text
                ),
                style: TextStyle(color: Colors.white), // White input text
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_outline,
                color: Colors.white, // White icon color
              ),
              onPressed: () {
                // Show info or alert about the password
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      "Password Information",
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    backgroundColor: Colors.black.withOpacity(0.8), // Dark background
                    content: const Text(
                      "Your default password is set to 'Password@123'. You can change it after logging in.",
                      style: TextStyle(color: Colors.white), // White text color
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.white), // White text color
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Department",
          style: const TextStyle(fontSize: 18, color: Colors.white), // White text color
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Transparent background
            borderRadius: BorderRadius.circular(8),
             // White border
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonFormField<String>(
            value: _selectedDepartment,
            decoration: const InputDecoration(
              border: InputBorder.none, // Remove default border
            ),
            hint: Text(
              "Select Department",
              style: TextStyle(color: Colors.white.withOpacity(0.7)), // White hint text
            ),
            dropdownColor: Colors.black.withOpacity(0.8), // Dropdown background color
            style: TextStyle(color: Colors.white), // White text color
            items: const [
              DropdownMenuItem(
                value: "Computer Science",
                child: Text("Computer Science"),
              ),
              DropdownMenuItem(
                value: "Information Technology",
                child: Text("Information Technology"),
              ),
              DropdownMenuItem(
                value: "Data Science",
                child: Text("Data Science"),
              ),
              DropdownMenuItem(
                value: "Computer Science and Technology",
                child: Text("Computer Science and Technology"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
            validator: (value) =>
                value == null ? "Please select a department" : null,
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
          'Add New User',
          style: TextStyle(
              fontFamily: 'Times New Roman', fontSize: 24, color: Colors.black), // Black text color
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
                width: MediaQuery.of(context).size.width * 0.6,
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
                        controller: _regnoController,
                        label: 'Reg No',
                        hint: 'Enter Registration Number',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        label: 'Name',
                        hint: 'Enter Name',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email ID',
                        hint: 'Enter Email ID',
                      ),
                      const SizedBox(height: 20),
                      _buildDepartmentDropdown(), // Department dropdown
                      const SizedBox(height: 20),
                      _buildPasswordField(_passwordController, 'Password'), // Password field
                      const SizedBox(height: 30),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _addUser,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                backgroundColor: Colors.blue.withOpacity(0.8), // Transparent button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Add User',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _uploadExcelSheet,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                backgroundColor: Colors.green.withOpacity(0.8), // Transparent button
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