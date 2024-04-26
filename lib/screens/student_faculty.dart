import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:college_connect/screens/student_singleFaculty.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';

class Faculty {
  final String facultyId;
  final String facultyName;
  final String facultyPic;
  final String facultyType;
  final String facultyDept;
  final String courseName;

  Faculty({
    required this.facultyId,
    required this.facultyName,
    required this.facultyPic,
    required this.facultyType,
    required this.facultyDept,
    required this.courseName,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      facultyId: json['faculty_id'].toString(),
      facultyName: json['faculty_name'].toString(),
      facultyPic: json['faculty_pic'].toString(),
      facultyType: json['faculty_type'].toString(),
      facultyDept: json['faculty_department'].toString(),
      courseName: json['course'].toString(),
    );
  }
}

class StudentFacultyPage extends StatefulWidget {
  @override
  _StudentFacultyPageState createState() => _StudentFacultyPageState();
}

class _StudentFacultyPageState extends State<StudentFacultyPage> {
  List<Faculty> _facultyList = [];

  @override
  void initState() {
    super.initState();
    _getFaculty();
  }

  Future<void> _getFaculty() async {
    final secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/student/get_faculty/',
        data: {
          'student_id': id,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          _facultyList = (response.data as List<dynamic>)
              .map((facultyData) => Faculty.fromJson(facultyData))
              .toList();
          print(_facultyList);
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch faculty',
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
        itemCount: _facultyList.length,
        itemBuilder: (context, index) {
          final faculty = _facultyList[index];
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentSingleFacultyPage(
                                  facultyId: faculty.facultyId)));
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
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20, // Adjust the radius as needed
                                    backgroundImage: NetworkImage(faculty
                                        .facultyPic), // Replace URL_HERE with the actual image URL
                                  ),
                                  SizedBox(
                                      width:
                                          10), // Add some spacing between the avatar and text
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        faculty.facultyName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Faculty Subject : ${faculty.courseName}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${faculty.facultyType}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${faculty.facultyDept}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
