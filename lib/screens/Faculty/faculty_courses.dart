import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:college_connect/screens/Faculty/faculty_singleCourse.dart';
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
      courseId: json['course_id'],
      courseCode: json['course_code'],
      stream: json['stream'],
      courseSem: json['course_sem'],
      courseName: json['course_name'],
    );
  }
}

class FacultyCoursesPage extends StatefulWidget {
  @override
  _FacultyCoursesPageState createState() => _FacultyCoursesPageState();
}

class _FacultyCoursesPageState extends State<FacultyCoursesPage> {
  List<Course> _courseList = [];
  List<Course> _filteredCourseList = [];
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
        _filteredCourseList = List.from(_courseList);
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

  void _filterCourses(String query) {
    setState(() {
      _filteredCourseList = _courseList.where((course) {
        return course.courseName.toLowerCase().contains(query.toLowerCase()) ||
            course.courseCode.toLowerCase().contains(query.toLowerCase()) ||
            course.stream.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Your Courses',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo.shade800, width: 1),
                color: Colors.white, // Background color of the search bar
              ),
              child: TextField(
                onChanged: _filterCourses, // Call _filterCourses on text change
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  border: InputBorder.none, // Remove border
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCourseList.length, // Use _filteredCourseList
              itemBuilder: (context, index) {
                final course =
                    _filteredCourseList[index]; // Use _filteredCourseList
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FacultySingleCoursePage(
                                courseId: course.courseId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double
                              .infinity, // Expand to the width of the page
                          child: Card(
                            surfaceTintColor: Colors.transparent,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.indigo.shade800,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 20.0,
                                top: 10.0,
                                bottom: 10.0,
                              ), // Add left padding
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
                                  Text(
                                    'Stream: ${course.stream}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          color: Colors.black.withOpacity(0.5),
                        ), // Horizontal divider
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/facultyAttendance');
        },
        child: Icon(Icons.calendar_today),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 2, // Set the current index accordingly
        onItemSelected: (index) {
          // Handle navigation to other pages
        },
      ),
    );
  }
}
