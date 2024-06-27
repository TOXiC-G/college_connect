import 'package:flutter/material.dart';
import '../common/navbar.dart';
import '../common/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import '../api/firebase_api.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../common/dio.config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:core';
import 'package:college_connect/screens/student_singleCourse.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    getTimetable(context);
  }

  String upcomingClass = '';
  String currentClass = '';

  String upcomingClassStartTime = '';
  String currentClassStartTime = '';

  String upcomingClassEndTime = '';
  String currentClassEndTime = '';

  String upcomingClassId = '';
  String currentClassId = '';

  String _getCurrentDay() {
    // Get the current date and time
    DateTime now = DateTime.now();
    // Get the current day of the week (Monday to Sunday: 1 to 7)
    int currentDayOfWeek = now.weekday;
    // Map the current day of the week to its name
    Map<int, String> daysOfWeek = {
      1: 'mon',
      2: 'tues',
      3: 'wed',
      4: 'thurs',
      5: 'fri',
      6: 'sat',
      7: 'sun',
    };
    // Return the corresponding day name
    return daysOfWeek[currentDayOfWeek] ?? '';
  }

  String _getCurrentTime() {
    // Get the current date and time
    DateTime now = DateTime.now();
    // Format the current time as HH:mm
    String formattedTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    // Return the formatted time
    return formattedTime;
  }

  Future<void> getTimetable(BuildContext contex) async {
    const secureStorage = FlutterSecureStorage();
    // const String apiUrl = 'http://192.168.0.104:8000/api/faculty/get_courses/'; //Playit
    late Map<String, dynamic> timetableData;
    String? id = await secureStorage.read(key: 'id');
    String? role = await secureStorage.read(key: 'role');
    try {
      final dioClient = DioClient();
      String? token = await secureStorage.read(key: 'accessToken');
      String tokenString = token.toString();
      dioClient.dio.options.headers['Authorization'] = 'Bearer $tokenString';
      final Response response = await dioClient.dio.post(
        '/api/timetable/',
        data: {
          'id': id,
          'role': 'student',
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        //print(response.data);
        timetableData = response.data;
        timetableData.forEach((syllabus, timetable) {
          //print(syllabus);
          // print(day + courses);
          // Get the current day's timetable
          // if (day == _getCurrentDay()) {
          if (syllabus == 'mon') {
            List<String> keys = timetable.keys.toList();
            // print(day);
            // String currentTime = _getCurrentTime();
            String currentTime = '12:30';
            int currentHour = int.parse(currentTime.split(':')[0]);
            for (String hour in keys) {
              var course = timetable[hour];
              //print(course);
              int hourSplit = int.parse(hour.substring(0, 2));
              if (hour.substring(0, 2) == currentHour.toString()) {
                //print("YEET");
                int temp = hourSplit + 1;
                String tempHour = '$temp${hour.substring(2)}';
                setState(() => {
                      currentClass = course['course_name'],
                      currentClassStartTime = hour,
                      currentClassEndTime = tempHour,
                      currentClassId = course['course_id'].toString(),
                    });
              }

              if (hourSplit > currentHour) {
                if (upcomingClassStartTime == '') {
                  int temp = hourSplit + 1;
                  String tempHour = '$temp${hour.substring(2)}';
                  setState(() => {
                        upcomingClass = course['course_name'],
                        upcomingClassStartTime = hour,
                        upcomingClassEndTime = tempHour,
                        upcomingClassId = course['course_id'].toString(),
                      });
                } else if (hourSplit <
                    int.parse(upcomingClassStartTime.substring(0, 2))) {
                  int temp = hourSplit + 1;
                  String tempHour = '$temp${hour.substring(2)}';
                  setState(() => {
                        upcomingClass = course['course_name'],
                        upcomingClassStartTime = hour,
                        upcomingClassEndTime = tempHour,
                        upcomingClassId = course['course_id'].toString(),
                      });
                }
              }
            }
            ;
          }
        });
        setState(() => {});
        print('Current class: $currentClass');
        print('Upcoming class: $upcomingClass');
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

  @override
  Widget build(BuildContext context) {
    return CommonSideBar(
      title: 'Welcome GEC Student',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${_getCurrentDayAndDate()}',
                style: TextStyle(fontSize: 18, fontFamily: 'Jost'),
              ),

              SizedBox(height: 16),
              if (currentClass != '')
                _buildClassCard(
                  id: currentClassId,
                  type: 'current',
                  title: currentClass,
                  time:
                      'Start: ${currentClassStartTime} | End: ${currentClassEndTime}',
                  bgColor: Color(0xFFFAFFFA),
                  buttonLabel: 'View Class',
                  buttonColor: Colors.white,
                  buttonStrokeColor: Color(0xFF167E1A),
                ),
              SizedBox(height: 16),
              if (upcomingClass != '')
                _buildClassCard(
                  id: upcomingClassId,
                  type: 'upcoming',
                  title: upcomingClass,
                  time:
                      'Start: ${upcomingClassStartTime} | End: ${upcomingClassEndTime}',
                  bgColor: Colors.white,
                  buttonLabel: 'View Class',
                  buttonColor: Colors.white,
                  buttonStrokeColor: Colors.blue,
                ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildClickableCard(
                      label: 'Assignments',
                      icon: PhosphorIcons.bookOpenText(PhosphorIconsStyle.thin),
                      onTap: () {
                        Navigator.pushNamed(context, '/assignments');
                        // Handle My Assignments tap
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildClickableCard(
                      label: 'My Marks',
                      icon: PhosphorIcons.checkFat(PhosphorIconsStyle.thin),
                      onTap: () {
                        Navigator.pushNamed(context, '/studentMarks');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/timetable');
                      },
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Rounded corners
                          side:
                              BorderSide(color: Colors.indigo), // Border color
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('View Timetable',
                              style: (TextStyle(
                                color: Colors.indigo,
                                fontSize: 16,
                              ))),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Colors.indigo,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
              // _buildImageCard(
              //   imagePath: 'assets/images/timetable.png',
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required String id,
    required String title,
    required String type,
    required Color bgColor,
    required String time,
    required String buttonLabel,
    required Color buttonColor,
    required Color buttonStrokeColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: buttonStrokeColor, width: 2),
      ),
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title),
            Text(time),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentSingleCoursePage(courseId: id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                onPrimary: buttonStrokeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: buttonStrokeColor, width: 2),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClickableCard({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        // color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 4, // Add elevation for a slight shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.indigo.shade800, width: 1),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // color: Colors.white, // Pure white background
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.indigo.shade800, // Change icon color as desired
              ),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black, // Change text color as desired
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard({required String imagePath}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }

  String _getCurrentDayAndDate() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date using the desired format
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(now);

    return formattedDate;
  }
}

void main() async {
  print("DEFINITELY IN MAIN");

  runApp(MaterialApp(
    home: HomePage(),
  ));
}
