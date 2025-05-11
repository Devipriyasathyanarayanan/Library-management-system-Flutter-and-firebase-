import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin.dart';
import 'profile.dart';
import 'homepage.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Function to clear all fields
  void _clearFields() {
    regNoController.clear();
    passwordController.clear();
  }

  Future<void> _loginUser(BuildContext context) async {
    String regNo = regNoController.text.trim();
    String password = passwordController.text.trim();

    if (_formKey.currentState!.validate()) {
      if (regNo == "admin" && password == "admin") {
        _showSuccessMessage(context, "Admin Login Successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
        return;
      }

      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(regNo).get();

        if (!userDoc.exists) {
          _showErrorMessage(context, "User not found. Please check your Reg No.");
          return;
        }

        String storedPassword = userDoc['password'];
        bool firstLogin = userDoc['first_login'] ?? true;

        if (password != storedPassword) {
          _showErrorMessage(context, "Incorrect Password. Try again.");
          return;
        }

        if (firstLogin) {
          _showResetPasswordDialog(context, regNo);
        } else {
          _showSuccessMessage(context, "Login Successful!");
          // Navigate to the HomePageAfterLogin after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageAfterLogin(regNo: regNo), // Pass regNo to HomePageAfterLogin
            ),
          );
        }
      } catch (e) {
        _showErrorMessage(context, "Login failed. Try again later.");
      }
    }
  }

  void _showResetPasswordDialog(BuildContext context, String regNo) {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent dialog background
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4, // Minimize width
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7), // Semi-transparent background
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        // New Password Field
                        TextField(
                          controller: newPasswordController,
                          obscureText: _obscureNewPassword,
                          decoration: InputDecoration(
                            labelText: "New Password",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureNewPassword = !_obscureNewPassword;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Password must be at least 8 characters, include 1 uppercase, 1 lowercase, and 1 special character.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Confirm Password Field
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Cancel Button
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white), // White border
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Reset Password Button
                            ElevatedButton(
                              onPressed: () async {
                                String newPassword = newPasswordController.text.trim();
                                String confirmPassword = confirmPasswordController.text.trim();
                                final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\W).{8,}$');

                                if (newPassword.isEmpty || confirmPassword.isEmpty) {
                                  _showErrorMessage(context, "Please enter all fields.");
                                  return;
                                }
                                if (newPassword != confirmPassword) {
                                  _showErrorMessage(context, "Passwords do not match.");
                                  return;
                                }
                                if (!passwordRegex.hasMatch(newPassword)) {
                                  _showErrorMessage(context, "Password must be at least 8 characters, include 1 uppercase, 1 lowercase, and 1 special character.");
                                  return;
                                }

                                try {
                                  await _firestore.collection('users').doc(regNo).update({
                                    'password': newPassword,
                                    'first_login': false,
                                  });

                                  Navigator.pop(context);
                                  _showSuccessMessage(context, "Password reset successful! Please login again.");
                                  _clearFields(); // Clear the fields after successful password reset
                                } catch (e) {
                                  _showErrorMessage(context, "Failed to update password. Try again.");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Transparent background
                                side: BorderSide(color: Colors.white), // White border
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                "Reset Password",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.8, // Adjusted height
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
                  crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  children: [
                    // Logo Image at the top with no bottom padding
                    Image.asset(
                      'images/logo.png',
                      height: 320, // Slightly increased height
                      width: 220, // Slightly increased width
                    ),
                    const SizedBox(height:0), // Reduced space between logo and fields
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                            children: [
                              TextFormField(
                                controller: regNoController,
                                decoration: InputDecoration(
                                  labelText: 'Reg No',
                                  labelStyle: TextStyle(color: Colors.white), // White text color
                                  border: const OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                ),
                                style: TextStyle(color: Colors.white), // White text color
                                validator: (value) => value!.isEmpty ? "Please enter your Reg No" : null,
                                onFieldSubmitted: (value) {
                                  // Trigger login when Enter is pressed
                                  _loginUser(context);
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.white), // White text color
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min, // To keep the icons close
                                    children: [
                                      Tooltip(
                                        message: "First-time login? Use the default password: Password@123",
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.info_outline,
                                            color: Colors.white, // White icon color
                                          ),
                                          onPressed: () {
                                            // Show a tooltip or dialog with the default password info
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "First-time login? Use the default password: Password@123",
                                                  style: TextStyle(color: Colors.white), // White text color
                                                ),
                                                backgroundColor: Colors.blue,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.white, // White icon color
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                style: TextStyle(color: Colors.white), // White text color
                                validator: (value) => value!.isEmpty ? "Please enter your password" : null,
                                onFieldSubmitted: (value) {
                                  // Trigger login when Enter is pressed
                                  _loginUser(context);
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => _loginUser(context),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.blue.withOpacity(0.8), // Transparent button
                                ),
                                child: const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                              const SizedBox(height: 15),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                                },
                                child: const Text(
                                  "Don't have an account? Sign up",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}