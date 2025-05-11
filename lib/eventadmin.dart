import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_core/firebase_core.dart'; // Firebase Core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AdminUpdateEventPage(),
  ));
}

class AdminUpdateEventPage extends StatefulWidget {
  @override
  _AdminUpdateEventPageState createState() => _AdminUpdateEventPageState();
}

class _AdminUpdateEventPageState extends State<AdminUpdateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color.fromARGB(255, 62, 98, 62),
            colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 62, 98, 62)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateEvent() async {
    String eventName = _eventNameController.text;
    String eventDescription = _eventDescriptionController.text;
    String eventDate = _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : "No date selected";

    if (eventName.isEmpty || eventDescription.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'eventName': eventName,
        'eventDescription': eventDescription,
        'eventDate': eventDate,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Event Updated Successfully!"), backgroundColor: Colors.green),
      );

      _eventNameController.clear();
      _eventDescriptionController.clear();
      setState(() {
        _selectedDate = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update event: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "UPDATE EVENT",
                  style: TextStyle(
                    color: Color.fromARGB(255, 62, 98, 62),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _eventNameController,
                      decoration: InputDecoration(
                        labelText: "Event Name",
                        prefixIcon: Icon(Icons.event, color: Color.fromARGB(255, 62, 98, 62)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: _selectedDate == null ? "Select Event Date" : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            prefixIcon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 62, 98, 62)),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _eventDescriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: "Event Description",
                        prefixIcon: Icon(Icons.description, color: Color.fromARGB(255, 62, 98, 62)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 62, 98, 62),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        "UPDATE EVENT",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}