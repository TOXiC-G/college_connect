// Import necessary packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:college_connect/screens/home_page.dart';
import 'package:college_connect/screens/attendance.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  CommonBottomNavigationBar({
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      currentIndex: currentIndex,
      onTap: (index) {
        // Trigger the callback to handle navigation
        onItemSelected(index);

        // You can add more logic here if needed
        // For example, pushing different pages based on the index
        switch (index) {
          case 0:
            // Navigator.pushNamed(context, '/home');
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            // Navigator.pushNamed(context, '/attendance');
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AttendancePage()),
            );
            break;
          case 2:
            Navigator.pushNamed(context, '/courses');
            break;
          case 3:
            Navigator.pushNamed(context, '/map');
          // break;
          case 4:
            Navigator.pushNamed(context, '/profile');
          // Add more cases as needed
        }
      },
      selectedLabelStyle: TextStyle(
        color: Colors.green,
        fontFamily: 'Mulish',
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.black,
        fontFamily: 'Mulish',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
