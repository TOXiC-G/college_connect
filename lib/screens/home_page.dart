import 'package:flutter/material.dart';
import '../common/navbar.dart';
import '../common/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import '../api/firebase_api.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonSideBar(
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
                    label: 'My Assignments',
                    icon: Icons.assignment,
                    onTap: () {
                      Navigator.pushNamed(context, '/assignments');
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
              // _buildImageCard(
              //   imagePath: 'assets/images/timetable.png',
              // ),
            ],
          ),
        ),
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
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date using the desired format
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(now);

    return formattedDate;
  }
}

void main() async {
  print("DEFINITELY IN MAIN");

  runApp(MaterialApp(
    home: HomePage(),
  ));
}
