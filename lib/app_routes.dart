// lib/app_routes.dart
import 'package:flutter/material.dart';
import 'package:college_connect/screens/home_page.dart';
import 'package:college_connect/screens/login_screen.dart';
import 'package:college_connect/screens/attendance.dart';
import 'package:college_connect/screens/map.dart';
import 'package:college_connect/screens/profile.dart';
import 'package:college_connect/screens/notifications.dart';
import 'package:college_connect/screens/assignments.dart';
import 'package:college_connect/screens/faculty_home_page.dart';
import 'package:college_connect/screens/Faculty/faculty_attendance.dart';
import 'package:college_connect/screens/Faculty/faculty_notifications.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String attendance = '/attendance';
  static const String map = '/map';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String assignments = '/assignments';
  static const String facultyHome = '/facultyHome';
  static const String facultyAttendance = '/facultyAttendance';
  static const String facultyNotifications = '/facultyNotifications';

  static Map<String, WidgetBuilder> define() {
    return {
      login: (context) => LoginScreen(),
      home: (context) => HomePage(),
      attendance: (context) => AttendancePage(),
      map: (context) => MapPage(),
      profile: (context) => ProfilePage(),
      notifications: (context) => NotificationsPage(),
      assignments: (context) => AssignmentsPage(),
      facultyHome: (context) => FacultyHomePage(),
      facultyAttendance: (context) => FacultyAttendancePage(),
      facultyNotifications: (context) => FacultyNotificationsPage()
      // Add more routes as needed
    };
  }
}
