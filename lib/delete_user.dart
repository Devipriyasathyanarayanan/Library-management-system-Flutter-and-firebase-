import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoveUserPage extends StatefulWidget {
  const RemoveUserPage({Key? key}) : super(key: key);

  @override
  _RemoveUserPageState createState() => _RemoveUserPageState();
}

class _RemoveUserPageState extends State<RemoveUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _regnoController = TextEditingController();
  bool _isUserFound = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _removeUser() async {
    String regno = _regnoController.text.trim();
    if (regno.isEmpty) return;

    DocumentSnapshot doc = await _firestore.collection('users').doc(regno).get();
    if (doc.exists) {
      await _firestore.collection('users').doc(regno).delete();
      _showMessage("User removed successfully!");
      _clearFields();
    } else {
      _showMessage("Reg No not found. Please enter a valid Reg No.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Remove User',
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

                      // Registration Number Field
                      _buildTextField(
                        controller: _regnoController,
                        label: 'Reg No',
                        hint: 'Enter Registration Number',
                      ),
                      const SizedBox(height: 30),

                      // Remove User Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _removeUser,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            backgroundColor: Colors.red.withOpacity(0.8), // Transparent button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Remove User',
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
          validator: (value) =>
              value!.isEmpty ? "Please enter $label" : null,
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _clearFields() {
    _regnoController.clear();
    setState(() {
      _isUserFound = false;
    });
  }
}