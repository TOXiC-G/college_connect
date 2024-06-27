import 'package:flutter/material.dart';
import 'package:college_connect/screens/Faculty/faculty_singleSubmission.dart';
import 'package:flutter/material.dart';
import 'package:college_connect/common/appbar.dart';
import 'package:college_connect/common/navbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:college_connect/screens/Faculty/faculty_singleITPage.dart';

class FacultyGradeStudentIT extends StatefulWidget {
  String assignmentId = '';
  List<Student> students = [];
  String totalMarks = '';

  FacultyGradeStudentIT({
    required this.assignmentId,
    required this.students,
    required this.totalMarks,
  });

  @override
  _FacultyGradeStudentITState createState() => _FacultyGradeStudentITState();
}

class _FacultyGradeStudentITState extends State<FacultyGradeStudentIT> {
  bool render = false;
  List<Student> students = [];
  int totalMarks = 0;
  void initState() {
    super.initState();
    getStudents();
    // Add your initialization code here
  }

  Future<void> getStudents() async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/faculty/get_single_IT/',
        data: {
          'assignment_id': widget.assignmentId,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          // submissions = (response.data['submissions'] as List)
          //     .map((submission) => Submission.fromJson(submission))
          //     .toList();
          students = (response.data['students'] as List)
              .map((student) => Student.fromJson(student))
              .toList();
        });
        render = true;
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

  Future<void> setStudentMarks(student_id, marks) async {
    try {
      if (int.parse(marks) < 0 ||
          int.parse(marks) > int.parse(widget.totalMarks)) {
        Fluttertoast.showToast(
          msg: 'Marks should be an integer and less than total marks',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      } else {
        final dioClient = DioClient();
        await dioClient.setAuthorizationHeader();
        final Response response = await dioClient.dio.post(
          'api/faculty/set_student_it_marks/',
          data: {
            'assignment_id': widget.assignmentId,
            'student_id': student_id,
            'marks': marks,
          },
        );

        if (response.statusCode == 200) {
          getStudents();
        } else {
          Fluttertoast.showToast(
            msg: 'Marks updated succesfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          getStudents();
        }
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Marks updated succesfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      getStudents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: 'Grade Students',
          automaticallyImplyLeading: true,
        ),
        body: Center(
            child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    students = widget.students
                        .where((student) =>
                            student.studentName
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            student.rollNo
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            ...students
                .map((student) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Card(
                        surfaceTintColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: student.marks != null
                                ? Colors.green
                                : Colors.red,
                            width: 2.0, // Set the width of the border
                          ),
                          borderRadius: BorderRadius.circular(
                              8), // Optional: if you want rounded corners
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Student: ${student.studentName}'),
                                Text('Roll No: ${student.rollNo}'),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  onFieldSubmitted: (value) {
                                    if (int.parse(value) >
                                        int.parse(widget.totalMarks)) {
                                      Fluttertoast.showToast(
                                        msg:
                                            'Marks cannot be greater than total marks',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      setStudentMarks(student.studentId, value);
                                    }
                                  },
                                  onChanged: (value) {
                                    if (int.parse(value) >
                                        int.parse(widget.totalMarks)) {
                                      Fluttertoast.showToast(
                                        msg:
                                            'Marks cannot be greater than total marks',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  },
                                  initialValue: student.marks == null
                                      ? ''
                                      : student.marks.toString(),
                                  decoration: InputDecoration(
                                    labelText: 'Marks',
                                  ),
                                )
                              ],
                            )),
                      ),
                    )))
                .toList(),
          ],
        )),
        bottomNavigationBar: CommonBottomNavigationBar(
          // Add your navigation items here
          currentIndex: 0, // Set the current index accordingly
          onItemSelected: (index) {
            // Handle navigation to other pages
          },
        ));
  }
}
