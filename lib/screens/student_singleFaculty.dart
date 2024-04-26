import 'package:flutter/material.dart';
import '../../common/appbar.dart';
import '../../common/navbar.dart';
import 'package:college_connect/screens/student_courses.dart';
import '../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentSingleFacultyPage extends StatefulWidget {
  @override
  _StudentSingleFacultyPageState createState() =>
      _StudentSingleFacultyPageState();
  final String facultyId; // New parameter to hold the courseId
  const StudentSingleFacultyPage({
    Key? key,
    required this.facultyId, // Receive courseId as a parameter
  }) : super(key: key);
}

class Course {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String courseStream;
  Course({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.courseStream,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'].toString(),
      courseCode: json['course_code'].toString(),
      courseName: json['course_name'].toString(),
      courseStream: json['stream'].toString(),
    );
  }
}

class Faculty {
  final String facultyId;
  final String facultyName;
  final String facultyEmail;
  final String facultyPic;
  final String facultyDept;
  final String facultyType;
  final List<Course> courses;

  Faculty({
    required this.facultyId,
    required this.facultyName,
    required this.facultyEmail,
    required this.facultyPic,
    required this.facultyDept,
    required this.facultyType,
    required this.courses,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    List<dynamic> courseJsonList = json['courses'];
    List<Course> facultyList = courseJsonList
        .map((facultyJson) => Course.fromJson(facultyJson))
        .toList();

    return Faculty(
      facultyId: json['faculty_id'].toString(),
      facultyName: json['faculty_name'].toString(),
      facultyEmail: json['faculty_email'].toString(),
      facultyPic: json['faculty_pic'].toString(),
      facultyDept: json['faculty_department'].toString(),
      facultyType: json['faculty_type'].toString(),
      courses: facultyList,
    );
  }
}

class _StudentSingleFacultyPageState extends State<StudentSingleFacultyPage> {
  late String facultyId;
  late Faculty faculty;
  bool render = false;
  @override
  void initState() {
    super.initState();
    facultyId = widget.facultyId; // Access courseId from the widget property
    getSingleCourse(facultyId);
  }

  Future<void> getSingleCourse(String courseId) async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/student/get_single_faculty/',
        data: {
          'faculty_id': facultyId,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          faculty = Faculty.fromJson(response.data);
        });
        render = true;
        print(faculty);
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
    if (render) {
      return Scaffold(
        appBar: CommonAppBar(
          title: faculty.facultyName,
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(faculty.facultyPic),
              ),
              Text(
                'Faculty Email : ${faculty.facultyEmail}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Designation: ${faculty.facultyType}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Department: ${faculty.facultyDept}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Courses Taught',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: faculty.courses
                      .length, // Replace with the actual number of faculty members
                  itemBuilder: (context, index) {
                    var course = faculty.courses[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: Colors.indigo.shade800, width: 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '${course.courseName}',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Course Code ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${course.courseCode}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Course Dept ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${course.courseStream}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: 2, // Set the current index accordingly
          onItemSelected: (index) {
            // Handle navigation to other pages
          },
        ),
      );
    } else {
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }
}
