import 'package:college_connect/screens/student_selectMarks.dart';
import 'package:flutter/material.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:college_connect/screens/student_singleCourse.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      courseId: json['course_id'].toString(),
      courseCode: json['course_code'].toString(),
      stream: json['stream'].toString(),
      courseSem: json['course_sem'].toString(),
      courseName: json['course_name'].toString(),
    );
  }
}

class StudentMarksScreen extends StatefulWidget {
  @override
  _StudentMarksScreenState createState() => _StudentMarksScreenState();
}

class _StudentMarksScreenState extends State<StudentMarksScreen> {
  List<Course> _courseList = [];
  bool render = false;
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
        'api/student/get_courses/',
        data: {
          'student_id': id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _courseList = (response.data as List<dynamic>)
              .map((courseData) => Course.fromJson(courseData))
              .toList();
          render = true;
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
        title: 'My Marks',
        automaticallyImplyLeading: true,
      ),
      body: render == false
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: _courseList
                  .map(
                    (course) => ListTile(
                      title: Text(course.courseName),
                      subtitle: Text(course.courseCode),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentSelectMarksPage(
                              courseId: course.courseId,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
      drawer: Drawer(
          // Your drawer content goes here
          ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 2, // Set the current index accordingly
        onItemSelected: (index) {
          // Handle navigation to other pages
        },
      ),
    );
  }
}
