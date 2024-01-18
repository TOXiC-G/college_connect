import 'package:flutter/material.dart';
import '../common/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import '../api/firebase_api.dart';
import 'dart:io' show Platform;

class FacultyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, GEC Faculty',
          style: TextStyle(fontFamily: 'Jost'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/facultyNotifications');
              // Handle notification icon tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${_getCurrentDayAndDate()}',
                style: TextStyle(fontSize: 18, fontFamily: 'Jost'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildClassCard(
                title: 'Current Class: Cloud Computing (IT 531)',
                faculty: 'Faculty: Bipin Naik',
                time: 'Start: 9:00 AM | End: 10:00 AM',
                bgColor: Color(0xFFFAFFFA),
                buttonLabel: 'View Class',
                buttonColor: Colors.white,
                buttonStrokeColor: Color(0xFF167E1A),
              ),
              SizedBox(height: 16),
              _buildClassCard(
                title: 'Your Next Class: Data Analytics (CE723)',
                bgColor: Colors.white,
                faculty: 'Faculty: Mario Pinto',
                time: 'Start: 10:00 AM | End: 11:00 AM',
                buttonLabel: 'View Class',
                buttonColor: Colors.white,
                buttonStrokeColor: Colors.blue,
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildClickableCard(
                    label: 'Take Attendance',
                    icon: Icons.assignment,
                    onTap: () {
                      Navigator.pushNamed(context, '/facultyAttendance');
                      // Handle My Assignments tap
                    },
                  ),
                  // _buildClickableCard(
                  //   label: 'Announcements',
                  //   icon: Icons.announcement,
                  //   onTap: () {
                  //     // Handle Announcements and Notices tap
                  //   },
                  // ),
                ],
              ),
              SizedBox(height: 16),
              _buildImageCard(
                imagePath: 'assets/images/timetable.png',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0, // Set the index according to the current page
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }

  Widget _buildClassCard({
    required String title,
    required String faculty,
    required Color bgColor,
    required String time,
    required String buttonLabel,
    required Color buttonColor,
    required Color buttonStrokeColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: buttonStrokeColor, width: 2),
      ),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title),
            Text(faculty),
            Text(time),
            ElevatedButton(
              onPressed: () {
                // Handle View Class button tap
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                onPrimary: buttonStrokeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: buttonStrokeColor, width: 2),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableCard(
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40),
              SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard({required String imagePath}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  String _getCurrentDayAndDate() {
    // Implement logic to get the current day and date
    // For example, you can use the intl package:
    // https://pub.dev/packages/intl
    return 'Monday, November 20, 2023';
  }
}

void main() async {
  runApp(MaterialApp(
    home: FacultyHomePage(),
  ));
}
