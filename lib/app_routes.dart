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
import 'package:college_connect/screens/Faculty/faculty_announcements.dart';
import 'package:college_connect/screens/profile_gp.dart';
import 'package:college_connect/screens/CGPA_calculator.dart';
import 'package:college_connect/screens/Payment.dart';
import 'package:college_connect/screens/Faculty/faculty_annoucementClassSelect.dart';
import 'package:college_connect/screens/Faculty/faculty_makeAnnoucement.dart';
import 'package:college_connect/screens/Faculty/faculty_assignmentClassSelect.dart';
import 'package:college_connect/screens/Faculty/faculty_getAssignments.dart';
import 'package:college_connect/screens/Faculty/faculty_assignments.dart';
import 'package:college_connect/screens/Faculty/faculty_courses.dart';
import 'package:college_connect/screens/student_courses.dart';
import 'package:college_connect/screens/student_tabView.dart';
import 'package:college_connect/screens/timetable.dart';

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
  static const String profileGp = "/profileGp";
  static const String cgpaCalculator = '/cgpaCalculator';
  static const String paymentHome = '/paymentHome';
  static const String facultyAnnoucements = '/facultyAnnouncements';
  static const String facultyAnnoucementClassSelect =
      '/facultyAnnouncementClassSelect';
  static const String facultyMakeAnnoucement = '/facultyMakeAnnouncement';
  static const String facultyAssignmentClassSelect =
      '/facultyAssignmentClassSelect';
  static const String facultyGetAssignments = '/facultyGetAssignments';
  static const String facultyAssignments = '/facultyAssignments';
  static const String facultyCourses = '/facultyCourses';
  static const String studentTabs = '/studentTabs';

  static const String studentCourses = '/studentCourses';
  static const String marks = '/marks';
  static const String timetable = "/timetable";
  static Map<String, WidgetBuilder> define() {
    return {
      login: (context) => LoginScreen(),
      home: (context) => HomePage(),
      attendance: (context) => AttendancePage(),
      map: (context) => GeoJsonDemo(),
      profile: (context) => ProfilePage(),
      notifications: (context) => NotificationsPage(),
      assignments: (context) => AssignmentsPage(),
      facultyHome: (context) => FacultyHomePage(),
      facultyAttendance: (context) => FacultyAttendancePage(),
      facultyNotifications: (context) => FacultyNotificationsPage(),
      profileGp: (context) => Profile_gp(),
      cgpaCalculator: (context) => CGPACalculator(),
      paymentHome: (context) => PaymentHome(),
      facultyAnnoucements: (context) => FacultyAnnouncementPage(),
      facultyAnnoucementClassSelect: (context) => SelectCoursesPage(),
      facultyMakeAnnoucement: (context) => MakeAnnouncementPage(),
      facultyAssignmentClassSelect: (context) =>
          FacultyAssignmentClassSelectPage(),
      facultyGetAssignments: (context) =>
          FacultyGetAssignmentsPage(fetchCourseId: () => ''),
      facultyAssignments: (context) => FacultyAssignmentsPage(),
      facultyCourses: (context) => FacultyCoursesPage(),
      studentTabs: (context) => TabPage(),
      timetable: (context) => TimetablePage(),
    };
  }
}
