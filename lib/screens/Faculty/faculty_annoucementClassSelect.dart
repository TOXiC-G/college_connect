import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import '../../common/dio.config.dart'; // Assuming this is the correct import path

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

class SelectCoursesPage extends StatefulWidget {
  @override
  _SelectCoursesPageState createState() => _SelectCoursesPageState();
}

class _SelectCoursesPageState extends State<SelectCoursesPage> {
  late List<Course> _courseList = [];
  List<String> _selectedCourseIds = [];

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
      final Response response =
          await dioClient.dio.post('api/faculty/get_courses/', data: {
        'faculty_id': id,
      });

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

  void _toggleCourseSelection(String courseId) {
    setState(() {
      if (_selectedCourseIds.contains(courseId)) {
        _selectedCourseIds.remove(courseId);
      } else {
        _selectedCourseIds.add(courseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Select Courses'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            for (Course course in _courseList) ...[
              GestureDetector(
                onTap: () {
                  _toggleCourseSelection(course.courseId);
                },
                child: Container(
                  color: _selectedCourseIds.contains(course.courseId)
                      ? Colors.green.withOpacity(0.3)
                      : Colors.transparent,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    course.courseName,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Divider(),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedCourseIds.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please select at least one course',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }

                Navigator.pushNamed(context, '/facultyMakeAnnouncement',
                    arguments: _selectedCourseIds);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
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

void main() {
  runApp(MaterialApp(
    home: SelectCoursesPage(),
  ));
}
