import 'package:flutter/material.dart';
import '../../common/appbar.dart';
import '../../common/navbar.dart';
import 'package:college_connect/screens/Faculty/faculty_courses.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';

class FacultySingleCoursePage extends StatefulWidget {
  @override
  FacultySingleCoursePageState createState() => FacultySingleCoursePageState();

  final String courseId; // New parameter to hold the courseId
  const FacultySingleCoursePage({
    Key? key,
    required this.courseId, // Receive courseId as a parameter
  }) : super(key: key);
}

class Course {
  final String courseId;
  final String courseName;
  final String courseCode;
  final String stream;
  final String courseSem;
  final String courseYear;
  final String scheme;
  // final List<Faculty> faculty;

  Course({
    required this.courseId,
    required this.courseCode,
    required this.stream,
    required this.courseSem,
    required this.scheme,
    required this.courseName,
    required this.courseYear,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'].toString(),
      courseCode: json['course_code'].toString(),
      stream: json['stream'].toString(),
      courseSem: json['course_sem'].toString(),
      courseName: json['course_name'].toString(),
      courseYear: json['course_year'].toString(),
      scheme: json['scheme'].toString(),
    );
  }
}

class FacultySingleCoursePageState extends State<FacultySingleCoursePage> {
  late String courseId;
  late Course course;
  bool render = false;
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
