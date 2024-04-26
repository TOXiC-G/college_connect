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

class StudentSingleCoursePage extends StatefulWidget {
  @override
  _StudentSingleCoursePageState createState() =>
      _StudentSingleCoursePageState();
  final String courseId; // New parameter to hold the courseId
  const StudentSingleCoursePage({
    Key? key,
    required this.courseId, // Receive courseId as a parameter
  }) : super(key: key);
}

class Faculty {
  final String facultyId;
  final String facultyName;
  final String facultyEmail;
  final String facultyType;
  final String department;
  final String facultyPic;
  Faculty({
    required this.facultyId,
    required this.facultyName,
    required this.facultyType,
    required this.department,
    required this.facultyEmail,
    required this.facultyPic,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      facultyId: json['faculty_id'].toString(),
      facultyName: json['faculty_name'].toString(),
      facultyEmail: json['faculty_email'].toString(),
      facultyType: json['faculty_type'].toString(),
      department: json['faculty_department'].toString(),
      facultyPic: json['faculty_pic'].toString(),
    );
  }
}

class Course {
  final String courseId;
  final String courseName;
  final String courseCode;
  final String stream;
  final String courseSem;
  final String courseYear;
  final String scheme;
  final List<Faculty> faculty;

  Course({
    required this.courseId,
    required this.courseCode,
    required this.stream,
    required this.courseSem,
    required this.scheme,
    required this.courseName,
    required this.courseYear,
    required this.faculty,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    List<dynamic> facultyJsonList = json['faculty'];
    List<Faculty> facultyList = facultyJsonList
        .map((facultyJson) => Faculty.fromJson(facultyJson))
        .toList();

    return Course(
      courseId: json['course_id'].toString(),
      courseCode: json['course_code'].toString(),
      stream: json['stream'].toString(),
      courseSem: json['course_sem'].toString(),
      courseName: json['course_name'].toString(),
      courseYear: json['course_year'].toString(),
      scheme: json['scheme'].toString(),
      faculty: facultyList,
    );
  }
}

class _StudentSingleCoursePageState extends State<StudentSingleCoursePage> {
  late String courseId;
  late Course course;
  bool render = false;
  @override
  void initState() {
    super.initState();
    courseId = widget.courseId; // Access courseId from the widget property
    getSingleCourse(courseId);
  }

  Future<void> getSingleCourse(String courseId) async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/student/get_single_course/',
        data: {
          'course_id': courseId,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          course = Course.fromJson(response.data);
        });
        render = true;
        print(course);
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
          title: course.courseName,
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Code: ${course.courseCode}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Scheme: ${course.scheme}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Stream: ${course.stream}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Semester: ${course.courseSem}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Year: ${course.courseYear}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Faculty Member(s):',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: course.faculty
                      .length, // Replace with the actual number of faculty members
                  itemBuilder: (context, index) {
                    var faculty = course.faculty[index];
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
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(faculty
                                          .facultyPic), // Placeholder image URL
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${faculty.facultyName}',
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
                                                  text: 'Faculty Type ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${faculty.facultyType}',
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
                                                  text: 'Faculty Department ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${faculty.department}',
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
                                                  text: 'Faculty Email ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${faculty.facultyEmail}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        right: 8.0), // Adjust the value as needed
                    child: ElevatedButton(
                      onPressed: () => {},
                      child: Text('ASSIGNMENTS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Colors
                            .transparent, // Set button color to transparent
                        onPrimary: Colors.indigo, // Set text color to indigo
                        side: BorderSide(
                            color: Colors.indigo), // Add indigo border
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8.0), // Adjust the value as needed
                    child: ElevatedButton(
                      onPressed: () => {},
                      child: Text('IT MARKS'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Colors
                            .transparent, // Set button color to transparent
                        onPrimary: Colors.indigo, // Set text color to indigo
                        side: BorderSide(
                            color: Colors.indigo), // Add indigo border
                      ),
                    ),
                  ),
                ],
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
