import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:college_connect/screens/student_singleCourse.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';

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

class StudentCoursesPage extends StatefulWidget {
  @override
  _StudentCoursesPageState createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
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
      body: ListView.builder(
        itemCount: _courseList.length,
        itemBuilder: (context, index) {
          final course = _courseList[index];
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentSingleCoursePage(
                                  courseId: course.courseId)));
                    },
                    child: Container(
                      width: double.infinity, // Expand to the width of the page
                      child: Card(
                        surfaceTintColor: Colors.transparent,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Colors.indigo.shade800, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0,
                              top: 10.0,
                              bottom: 10.0), // Add left padding
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.courseName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Course Code: ${course.courseCode}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       left: 20.0, right: 20.0, top: 10.0, bottom: 5.0),
                  //   child: Divider(
                  //       color: Colors.black
                  //           .withOpacity(0.5)), // Horizontal divider
                  // ),
                ],
              ));
        },
      ),
    );
  }
}
