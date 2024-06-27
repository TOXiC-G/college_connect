// Import necessary packages
import 'package:college_connect/common/appbar.dart';
import 'package:flutter/material.dart';
import '../common/navbar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Holiday {
  final String name;
  final String date;

  Holiday({required this.name, required this.date});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'].toString(),
      date: json['date'].toString(),
    );
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
      courseId: json['course_id'].toString(),
      courseCode: json['course_code'].toString(),
      stream: json['stream'].toString(),
      courseSem: json['course_sem'].toString(),
      courseName: json['course_name'].toString(),
    );
  }
}

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late List<Holiday> holidays = [];
  late List<int> holidayDates = [];
  late List<Course> courseList = [];
  // Placeholder for fetched attendance data
  late List<int> presentDates = [];

  // Placeholder for selected course in dropdown
  String? selectedCourse;

  // Placeholder for current month
  DateTime selectedMonth = DateTime.now();

  Future<void> fetchCourses(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    String? role = await secureStorage.read(key: 'role');
    String? id = await secureStorage.read(key: 'id');
    String api = 'api/${role}/get_courses/';
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        api,
        data: {
          '${role}_id': id,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> courseDataList = response.data;
        setState(() {
          courseList = courseDataList
              .map((courseData) => Course.fromJson(courseData))
              .toList();
        });
      }
    } catch (e) {
      print(e);
      // Show a toast message if there is an error
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> fetchAttendance(String courseId) async {
    const secureStorage = FlutterSecureStorage();
    String? role = await secureStorage.read(key: 'role');
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/attendance/',
        data: {
          'id': id,
          'role': role,
          'course_id': courseId,
          'month': selectedMonth.month,
          'year': selectedMonth.year,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> attendanceData = response.data;
        List<int> attendance =
            attendanceData.map((data) => int.parse(data)).toList();
        setState(() {
          presentDates = attendance;
        });
      }
    } catch (e) {
      print(e);
      // Show a toast message if there is an error
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> fetchHolidays() async {
    final dioClient = DioClient();
    await dioClient.setAuthorizationHeader();
    final Response response1 = await dioClient.dio.post(
      'api/get_holidays/',
      data: {
        'month': selectedMonth.month,
        'year': selectedMonth.year,
      },
    );
    if (response1.statusCode == 200) {
      List<dynamic> holidayData = response1.data;
      setState(() => holidays =
          holidayData.map((holiday) => Holiday.fromJson(holiday)).toList());
      setState(() => holidayDates = holidays
          .map((holiday) => int.parse(holiday.date.split('-')[2]))
          .toList());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCourses(context); // Call your API function here
    fetchHolidays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBar(automaticallyImplyLeading: false, title: 'ATTENDANCE'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown for selecting course
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white, // Set the background color to white
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
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
                          selectedCourse = newValue!;
                        });
                        fetchAttendance(newValue!);
                        print(newValue);
                        // Replace the comment with your API call for course-specific data
                      },
                      items: courseList
                          .map<DropdownMenuItem<String>>((Course course) {
                        return DropdownMenuItem<String>(
                          value: course.courseId,
                          child: Text(course.courseName),
                        );
                      }).toList(),
                    ),
                  ) // Dropdown arrow icon
                ],
              ),
            ),
            SizedBox(height: 20),

// Calendar
            TableCalendar(
              focusedDay: selectedMonth,
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),
              calendarFormat: CalendarFormat.month,
              onFormatChanged: (format) {},
              onPageChanged: (focusedDay) {
                fetchHolidays();
                selectedMonth = focusedDay;
                if (selectedCourse != null) {
                  fetchAttendance(selectedCourse!);
                }
              },
              onDaySelected: (selectedDay, focusedDay) {
                // Handle day selection if needed
                // print(selectedDay);
                if (presentDates.contains(selectedDay.day)) {
                  print(selectedDay);
                }
              },
              calendarBuilders: CalendarBuilders(
                // Customize the appearance of each day
                defaultBuilder: (context, date, _) {
                  if (presentDates.contains(date.day)) {
                    // Day is present, highlight in green
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.green.withOpacity(0.5),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else if (holidayDates.contains(date.day)) {
                    return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text("${date.day}",
                            style: TextStyle(color: Colors.red)));
                  } else {
                    return null;
                  }
                },
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF735BF2),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false, // Remove the extra text
                titleCentered: true,
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: holidays
                    .map((holiday) => ListTile(
                          title: Text(holiday.name),
                          subtitle: Text(holiday.date),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 1, // Set the index according to the current page
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AttendancePage(),
  ));
}
