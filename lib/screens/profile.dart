// Import necessary packages
import 'package:flutter/material.dart';
import '../common/navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatelessWidget {
  final secureStorage = FlutterSecureStorage();
  void _logout(BuildContext context) async {
    await secureStorage.deleteAll();
    Navigator.pushNamed(context, '/'); // Replace with your login screen route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
          style: TextStyle(color: Color(0xFF202244), fontFamily: 'Jost'),
        ),
        // Remove the back arrow
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular profile avatar acting as an upload button
              GestureDetector(
                onTap: () {
                  // Handle avatar upload button tap
                  // You can add image upload logic here
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue, // You can customize the color
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Text 'STUDENT ACCOUNT DETAILS'
              Text(
                'STUDENT ACCOUNT DETAILS',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),

              // Container with student details
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey), // Add border
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildAttribute('Full Name', 'Student Name'),
                    _buildDivider(),
                    _buildAttribute('Email ID', 'Student Email'),
                    _buildDivider(),
                    _buildAttribute('Roll No', 'Student Roll'),
                    _buildDivider(),
                    _buildAttribute('PR NO', 'STUDENT PR'),
                    _buildDivider(),
                    _buildAttribute('Admission Year', '20XX'),
                    _buildDivider(),
                    _buildAttribute('PROGRAM', 'PROGRAM NAME'),
                    _buildDivider(),
                    _buildAttribute('SEMESTER', 'Semester No.'),
                    _buildDivider(),
                    _buildAttribute('BATCH', 'Batch Name'),
                    _buildDivider(),
                    _buildAttribute('CLASS NO', 'Class No.'),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Divider
              Divider(height: 1, color: Colors.grey.withOpacity(0.7)),
              SizedBox(height: 20),

              // Logout and Change Password buttons
              _buildButton('LOGOUT', Colors.blue, context),
              SizedBox(height: 10),
              _buildButton('CHANGE PASSWORD', Colors.red, context),
              SizedBox(height: 20),

              // Divider
              Divider(height: 1, color: Colors.grey.withOpacity(0.7)),
              SizedBox(height: 20),

              // Custom navbar element with index value 4
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 4,
        onItemSelected: (index) {
          // Handle navigation based on index
        },
      ),
    );
  }

  Widget _buildAttribute(String attributeName, String attributeValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$attributeName :',
          style: TextStyle(fontFamily: 'Jost'),
        ),
        Text(
          attributeValue,
          style: TextStyle(fontFamily: 'Jost'),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.withOpacity(0.7));
  }

  Widget _buildButton(String text, Color color, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle button tap
        if (text == 'LOGOUT') {
          _logout(context);
        } else if (text == 'CHANGE PASSWORD') {
          // Handle change password
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        side: BorderSide(color: color, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontFamily: 'Jost', color: color),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
