// Import necessary packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:college_connect/screens/home_page.dart';
import 'package:college_connect/screens/attendance.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final secureStorage = FlutterSecureStorage();
  late final String? role;

  CommonBottomNavigationBar({
    required this.currentIndex,
    required this.onItemSelected,
  });

  Future<void> fetchRole() async {
    role = await secureStorage.read(key: 'role');
  }

  @override
  Widget build(BuildContext context) {
    fetchRole();
    return BottomNavigationBar(
      items: _buildBottomNavigationBarItems(),
      backgroundColor: Colors.indigo.shade800,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: (index) {
        // Trigger the callback to handle navigation
        onItemSelected(index);

        // You can add more logic here if needed
        // For example, pushing different pages based on the index
        switch (index) {
          case 0:
            if (role != null) if (role == 'student')
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => HomePage()),
              );
            else
              Navigator.pushNamed(context, '/facultyHome');
            break;
          case 1:
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AttendancePage()),
            );
            break;
          case 2:
            print("HERE");
            if (role != null) if (role == 'student')
              Navigator.pushNamed(context, '/studentTabs');
            else
              Navigator.pushNamed(context, '/facultyCourses');
            break;
          case 3:
            Navigator.pushNamed(context, '/map');
            break;
          case 4:
            Navigator.pushNamed(context, '/profile');
            break;
          // Add more cases as needed
        }
      },
      selectedLabelStyle: TextStyle(
        color: Colors.green,
        fontFamily: 'Mulish',
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: TextStyle(
        color: Colors.white,
        fontFamily: 'Mulish',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return <BottomNavigationBarItem>[
      _buildBottomNavigationBarItem(
        PhosphorIcons.house(PhosphorIconsStyle.thin),
        PhosphorIcons.house(PhosphorIconsStyle.fill),
        '',
      ),
      _buildBottomNavigationBarItem(
        PhosphorIcons.calendar(PhosphorIconsStyle.thin),
        PhosphorIcons.calendar(PhosphorIconsStyle.fill),
        '',
      ),
      _buildBottomNavigationBarItem(
        PhosphorIcons.book(PhosphorIconsStyle.thin),
        PhosphorIcons.book(PhosphorIconsStyle.fill),
        '',
      ),
      _buildBottomNavigationBarItem(
        PhosphorIcons.mapPin(PhosphorIconsStyle.thin),
        PhosphorIcons.mapPin(PhosphorIconsStyle.fill),
        '',
      ),
      _buildBottomNavigationBarItem(
        PhosphorIcons.userCircle(PhosphorIconsStyle.thin),
        PhosphorIcons.userCircle(PhosphorIconsStyle.fill),
        '',
      ),
    ];
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    IconData iconData,
    IconData activeIconData,
    String label,
  ) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.indigo.shade800,
      icon: PhosphorIcon(iconData, size: 24.0, color: Colors.white),
      activeIcon: PhosphorIcon(activeIconData, size: 24.0, color: Colors.white),
      label: label,
    );
  }
}
