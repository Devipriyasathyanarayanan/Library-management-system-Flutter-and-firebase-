import 'package:flutter/material.dart';   
import 'package:firebase_core/firebase_core.dart';  
import 'home.dart';  
import 'login.dart';  
import 'admin.dart';  
import 'about.dart';  
import 'book.dart';  
import 'event.dart';  
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: "AIzaSyBQr_9PNV-AafQ3GnJ7u_dWRrQ-jUhOAWs", 
    appId: "1:17637796239:web:d4c52692d9fcb80bd7c3fa", 
    messagingSenderId: "17637796239", 
    projectId: "library-management-d5ee8" )
);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Removes the debug tag
      initialRoute: '/home',  // Set homepage as the initial route
      routes: {
        '/login': (context) =>  LoginPage(),  // Route to Login Page
        '/home': (context) => const HomePage(),    // Route to Home Page
        '/admin': (context) => const AdminHomePage(),  // Route to Admin Page
        '/about': (context) => const Aboutpage(),  // Route to About Page
        '/book': (context) => const BooksPage(),   // Route to Book Details Page
      },
    );
  }
}
