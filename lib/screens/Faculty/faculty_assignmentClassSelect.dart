import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import '../../common/dio.config.dart';
import 'package:college_connect/screens/Faculty/faculty_getAssignments.dart';

class Course {
  final String courseId;
  final String courseCode;
  final String stream;
  final String courseSem;
  final String courseName;

  Course({
    required this.courseId,
    required this.courseCode,
    required this.stream,
    required this.courseSem,
    required this.courseName,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseCode: json['course_code'],
      stream: json['stream'],
      courseSem: json['course_sem'],
      courseName: json['course_name'],
    );
  }
}

class FacultyAssignmentClassSelectPage extends StatefulWidget {
  @override
  _FacultyAssignmentClassSelectPageState createState() =>
      _FacultyAssignmentClassSelectPageState();
}

class _FacultyAssignmentClassSelectPageState
    extends State<FacultyAssignmentClassSelectPage> {
  List<Course> _courseList = [];

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

  Future<void> _getCourses() async {
    final secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/faculty/get_courses/',
        data: {
          'faculty_id': id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _courseList = (response.data as List<dynamic>)
              .map((courseData) => Course.fromJson(courseData))
              .toList();
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch courses',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      print(error.toString());
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Select Class',
        automaticallyImplyLeading: true,
      ),
      body: ListView.builder(
        itemCount: _courseList.length,
        itemBuilder: (context, index) {
          final course = _courseList[index];
          return ListTile(
            title: Text(course.courseName),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacultyGetAssignmentsPage(
                          fetchCourseId: () => course.courseId)));
            },
          );
        },
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0,
        onItemSelected: (index) {
          print('Tapped on item $index');
        },
      ),
    );
  }
}
