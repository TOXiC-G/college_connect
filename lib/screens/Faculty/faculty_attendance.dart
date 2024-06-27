import 'package:flutter/material.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../common/dio.config.dart';

class Student {
  final String id;
  final String rollNumber;
  final String name;

  Student({required this.id, required this.rollNumber, required this.name});
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['student_id'],
      name: json['first_name'] + ' ' + json['last_name'],
      rollNumber: json['roll_no'],
    );
  }

  @override
  String toString() {
    return 'Student{id: $id, rollNumber: $rollNumber, name: $name}';
  }
}

class Course {
  final String courseId;
  final String courseCode;
  final String stream;
  final String courseSem;
  final String courseName;

  Course(
      {required this.courseId,
      required this.courseCode,
      required this.stream,
      required this.courseSem,
      required this.courseName});
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id'],
      courseCode: json['course_code'],
      stream: json['stream'],
      courseSem: json['course_sem'],
      courseName: json['course_name'],
    );
  }

  @override
  String toString() {
    return 'Course{id: $courseId, code: $courseCode, stream: $stream, sem: $courseSem, name: $courseName}';
  }
}

class FacultyAttendancePage extends StatefulWidget {
  @override
  _FacultyAttendancePageState createState() => _FacultyAttendancePageState();
}

class _FacultyAttendancePageState extends State<FacultyAttendancePage> {
  late List<Course> courseList = [];
  String? selectedCourse;

  Future<void> get_courses(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    // const String apiUrl = 'http://192.168.0.104:8000/api/faculty/get_courses/';
    const String apiUrl =
        'http://147.185.221.17:22244/api/faculty/get_courses/'; //Playit

    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      // String? token = await secureStorage.read(key: 'accessToken');
      // String tokenString = token.toString();
      // dioClient.dio.options.headers['Authorization'] = 'Bearer $tokenString';
      final Response response = await dioClient.dio.post(
        '/api/faculty/get_courses/',
        data: {
          'faculty_id': id,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        List<dynamic> courseDataList = response.data;
        setState(() {
          courseList = courseDataList
              .map((courseData) => Course.fromJson(courseData))
              .toList();
        });
      } else {
        // Failed login
        Fluttertoast.showToast(
          msg: 'Invalid credentials',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // Handle network or other errors
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

  late List<Student> studentList = [];
  late List<Student> currentStudentList = [];
  Future<void> getStudents(BuildContext context, courseId) async {
    const secureStorage = FlutterSecureStorage();
    // const String apiUrl =
    //     'http://192.168.0.104:8000/api/faculty/get_course_students/';
    const String apiUrl =
        'http://147.185.221.17:22244/api/faculty/get_course_students/'; //Playit
    try {
      final dioClient = DioClient();
      String? token = await secureStorage.read(key: 'accessToken');
      String tokenString = token.toString();
      dioClient.dio.options.headers['Authorization'] = 'Bearer $tokenString';
      final Response response = await dioClient.dio.post(
        '/api/faculty/get_course_students/',
        data: {
          'course_id': courseId,
        },
      );
      if (response.statusCode == 200) {
        // Successful login
        List<dynamic> studentDataList = response.data;
        setState(() {
          studentList = studentDataList
              .map((studentData) => Student.fromJson(studentData))
              .toList();
        });
        totalPages = (studentList.length / studentsPerPage).ceil();
        onPageChanged(currentPage);
        for (Student student in studentList) {
          attendanceStatus[student.id] = false;
        }
        print(studentList);
      } else {
        // Failed login
        Fluttertoast.showToast(
          msg: 'Invalid credentials',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // Handle network or other errors
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

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future setAttendance(BuildContext context, courseId, date, attendance) async {
    const secureStorage = FlutterSecureStorage();
    // const String apiUrl =
    //     'http://192.168.0.104:8000/api/faculty/set_course_attendance/';
    const String apiUrl =
        'http://147.185.221.17:22244/api/faculty/set_course_attendance/'; //Playit
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      // String? token = await secureStorage.read(key: 'accessToken');
      // String tokenString = token.toString();
      // dioClient.dio.options.headers['Authorization'] = 'Bearer $tokenString';
      final Response response = await dioClient.dio.post(
        '/api/faculty/set_course_attendance/',
        data: {
          'course_id': courseId,
          'date': date.toString(),
          'attendance': jsonEncode(attendance),
        },
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Attendance submitted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'An error occurred. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      // Handle network or other errors
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

  Map<String, bool> attendanceStatus = {};
  int currentPage = 0;
  int studentsPerPage = 5;
  int totalPages = 2;

  void onPageChanged(int pageNo) {
    currentStudentList = studentList.sublist(
        pageNo * studentsPerPage, pageNo * studentsPerPage + studentsPerPage);
    // You can add additional logic here based on the new page value
  }

  @override
  void initState() {
    super.initState();
    get_courses(context); // Call your API function here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBar(title: 'ATTENDANCE', automaticallyImplyLeading: true),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: Row(children: [
                  Expanded(
                      child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCourse,
                    hint: const Text('SELECT COURSE',
                        style: TextStyle(
                            color: Color(0xFF202244),
                            fontFamily: 'Jost',
                            fontSize: 16)),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCourse = newValue;
                        getStudents(context, newValue);
                      });
                    },
                    items: courseList.isEmpty
                        ? [DropdownMenuItem<String>(child: Text('Loading...'))]
                        : courseList.map((Course course) {
                            return DropdownMenuItem<String>(
                              value: course.courseId,
                              child: Text(course.courseName),
                            );
                          }).toList(),
                  ))
                ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(fontFamily: 'Jost', fontSize: 20)),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: currentPage > 0
                        ? Icon(Icons.arrow_left, size: 30)
                        : Opacity(
                            opacity: 0.5,
                            child: Icon(Icons.arrow_left, size: 30)),
                    onPressed: () {
                      if (currentPage > 0) {
                        setState(() {
                          currentPage--;
                          onPageChanged(currentPage);
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: currentStudentList.isEmpty
                          ? [Text('Select A Course...')]
                          : currentStudentList.map<Widget>((Student student) {
                              return buildStudentRow(student);
                            }).toList(),
                    ),
                  ),
                  IconButton(
                    icon: currentPage < totalPages - 1
                        ? Icon(Icons.arrow_right, size: 30)
                        : Opacity(
                            opacity: 0.5,
                            child: Icon(Icons.arrow_right, size: 30)),
                    onPressed: () {
                      // Check if there are more pages
                      if (currentPage < totalPages - 1) {
                        setState(() {
                          currentPage++;
                          onPageChanged(currentPage);
                        });
                      }
                    },
                  ),
                ],
              )),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // Submit attendance
                            setAttendance(context, selectedCourse, selectedDate,
                                attendanceStatus);
                          },
                          child: Text('Submit'))
                    ],
                  ))
            ],
          )),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 2, // Set the index according to the current page
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }

  Widget buildStudentRow(Student student) {
    bool isGreenSelected = attendanceStatus[student.id] ?? false;
    bool isRedSelected = !isGreenSelected;

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.name,
                textAlign: TextAlign.left,
                style: TextStyle(fontFamily: 'Jost', fontSize: 20),
              ),
              Text(student.rollNumber,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontFamily: 'Jost', fontSize: 20)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    attendanceStatus[student.id] = true;
                  });
                },
                child: Icon(
                  size: 30,
                  isGreenSelected ? Icons.circle : Icons.circle_outlined,
                  color: Colors.green[600],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() {
                    attendanceStatus[student.id] = false;
                  });
                },
                child: Icon(
                  size: 30,
                  isRedSelected ? Icons.circle : Icons.circle_outlined,
                  color: Colors.red[600],
                ),
              ),
            ],
          ),
        ],
      ),
      _buildDivider()
    ]);
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.withOpacity(0.7));
  }
}
