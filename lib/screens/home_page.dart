import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  BottomNavigationBarItem _buildBottomNavBarItem(
      IconData icon, String label, Color color,
      {bool selected = false}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: selected ? Color(0xFF167F71) : Color(0xFF202244)),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, GEC Student'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon tap
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${_getCurrentDayAndDate()}',
              style: TextStyle(fontSize: 18),
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
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Handle search icon tap
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildClassCard(
              title: 'Current Class: Cloud Computing (IT 531)',
              faculty: 'Faculty: Bipin Naik',
              time: 'Start: 9:00 AM | End: 10:00 AM',
              buttonLabel: 'View Class',
              buttonColor: Colors.white,
              buttonStrokeColor: Color(0xFF167E1A),
            ),
            SizedBox(height: 16),
            _buildClassCard(
              title: 'Your Next Class: Data Analytics (CE723)',
              faculty: 'Faculty: Mario Pinto',
              time: 'Start: 10:00 AM | End: 11:00 AM',
              buttonLabel: 'View Class',
              buttonColor: Colors.transparent,
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
                    // Handle My Assignments tap
                  },
                ),
                _buildClickableCard(
                  label: 'Announcements and Notices',
                  icon: Icons.announcement,
                  onTap: () {
                    // Handle Announcements and Notices tap
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildImageCard(
              imagePath: 'assets/timetable.png',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildBottomNavBarItem(Icons.home, 'Home', Colors.green,
              selected: true),
          _buildBottomNavBarItem(Icons.mail, 'Inbox', Colors.black),
          _buildBottomNavBarItem(
              Icons.library_books, 'My Courses', Colors.black),
          _buildBottomNavBarItem(Icons.map, 'Map', Colors.black),
          _buildBottomNavBarItem(Icons.person, 'Profile', Colors.black),
        ],
      ),
    );
  }

  Widget _buildClassCard({
    required String title,
    required String faculty,
    required String time,
    required String buttonLabel,
    required Color buttonColor,
    required Color buttonStrokeColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Color(0xFF167E1A), width: 2),
      ),
      color: Color(0xFFFAFFFA),
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

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
