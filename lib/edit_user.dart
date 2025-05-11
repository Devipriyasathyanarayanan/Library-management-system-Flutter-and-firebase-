import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _regnoController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedDepartment;
  bool _isRegnoValid = false; // To track if regno is valid and fetched

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Email validation regex
  final _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  // Password validation regex
  final _passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  Future<void> _fetchUserDetails() async {
    final regno = _regnoController.text.trim();

    if (regno.isEmpty) {
      _showErrorMessage("Please enter a registration number.");
      return;
    }

    final docRef = _firestore.collection('users').doc(regno);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      _showErrorMessage("Not a valid user.");
      setState(() {
        _isRegnoValid = false; // Regno is invalid
        _clearFields(); // Clear all fields
      });
    } else {
      final userData = docSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['name'];
        _emailController.text = userData['email'];
        _passwordController.text = userData['password'];
        _selectedDepartment = userData['department'];
        _isRegnoValid = true; // Regno is valid and details are fetched
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final regno = _regnoController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Validate email format
      if (!_emailRegex.hasMatch(email)) {
        _showErrorMessage("Please enter a valid email address.");
        return;
      }

      // Validate password format
      if (!_passwordRegex.hasMatch(password)) {
        _showErrorMessage("Password must be at least 8 characters long, contain one uppercase letter, one lowercase letter, one number, and one special character.");
        return;
      }

      try {
        // Update user data in Firestore
        await _firestore.collection('users').doc(regno).update({
          'name': _nameController.text.trim(),
          'email': email,
          'password': password,
          'department': _selectedDepartment,
        });

        _showSuccessMessage("User updated successfully.");
      } catch (e) {
        _showErrorMessage("Failed to update user: $e");
      }
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
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    setState(() {
      _selectedDepartment = null;
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool readOnly = false,
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
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) => value!.isEmpty ? "Please enter $label" : null,
          onFieldSubmitted: (value) {
            if (label == 'Reg No') {
              _fetchUserDetails(); // Fetch details when Enter is pressed
            }
          },
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
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: 'Enter Password',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            labelStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter a password";
            } else if (!_passwordRegex.hasMatch(value)) {
              return "Password must be at least 8 characters long, contain one uppercase letter, one lowercase letter, one number, and one special character.";
            }
            return null;
          },
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
            value: _selectedDepartment,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            hint: Text(
              "Select Department",
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            dropdownColor: Colors.black.withOpacity(0.8),
            style: TextStyle(color: Colors.white),
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
            validator: (value) => value == null ? "Please select a department" : null,
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
          'Edit User',
          style: TextStyle(
              fontFamily: 'Times New Roman', fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
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
                        controller: _regnoController,
                        label: 'Reg No',
                        hint: 'Enter Registration Number',
                        readOnly: _isRegnoValid, // Make regno read-only after fetching details
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
                      _buildDepartmentDropdown(),
                      const SizedBox(height: 20),
                      _buildPasswordField(_passwordController, 'Password'),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isRegnoValid ? _updateUser : null, // Disable if regno is invalid
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            backgroundColor: Colors.blue.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Update User',
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