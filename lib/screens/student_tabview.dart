import 'package:college_connect/common/navbar.dart';
import 'package:flutter/material.dart';
import 'package:college_connect/screens/student_courses.dart';
import 'package:college_connect/screens/student_faculty.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabPage(),
    );
  }
}

class TabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          automaticallyImplyLeading: false,
          title: Text('My Courses', style: TextStyle(color: Colors.white)),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Courses'),
              Tab(text: 'Faculty'),
            ],
            indicatorColor:
                Colors.white, // Add this line to set the indicator color
            labelColor: Colors.white, // Add this line to set the label color
            unselectedLabelColor: Colors
                .grey, // Add this line to set the color of unselected labels
            // backgroundColor: Colors.white, // Add this line to set the background color
          ),
        ),
        body: TabBarView(
          children: [
            StudentCoursesPage(),
            StudentFacultyPage(),
          ],
        ),
        bottomNavigationBar: CommonBottomNavigationBar(
            currentIndex: 2,
            onItemSelected: (index) {
              // Handle navigation based on index
            }),
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Courses'),
    );
  }
}

class FacultyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Faculty'),
    );
  }
}
