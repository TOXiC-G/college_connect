import 'package:flutter/material.dart';
import '../common/dio.config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../common/navbar.dart';
import '../common/appbar.dart';
import 'package:data_table_2/data_table_2.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final days = ["Mon", "Tues", "Wed", "Thurs", "Fri"];
  final timeSlots = ["0900", "1000", "1115", "1215", "1400", "1500", "1600"];
  Map<String, dynamic> timetableData = {};
  Future<void> getTimetable(BuildContext contex) async {
    const secureStorage = FlutterSecureStorage();
    // const String apiUrl = 'http://192.168.0.104:8000/api/faculty/get_courses/'; //Playit

    String? id = await secureStorage.read(key: 'id');
    String? role = await secureStorage.read(key: 'role');
    String? user = await secureStorage.read(key: 'user');

    String username = 'GEC Faculty';
    if (user != null) {
      setState(() => username = user);
    }

    try {
      final dioClient = DioClient();
      String? token = await secureStorage.read(key: 'accessToken');
      String tokenString = token.toString();
      dioClient.dio.options.headers['Authorization'] = 'Bearer $tokenString';
      String apiUrl = '/api/timetable/';
      if (role == 'faculty') apiUrl = '/api/faculty/timetable/';

      final Response response = await dioClient.dio.post(
        apiUrl,
        data: {
          'id': id,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        // Successful login
        setState(() => timetableData = response.data);
        print("TIMETABLE");
        print(timetableData);
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
  void initState() {
    super.initState();
    getTimetable(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Timetable',
        automaticallyImplyLeading: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (timetableData.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return orientation == Orientation.portrait
                ? buildPortraitTimetable()
                : buildLandscapeTimetable();
          }
        },
      ),
      bottomNavigationBar: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return CommonBottomNavigationBar(
              currentIndex: 0,
              onItemSelected: (index) {
                // Handle navigation to different pages
                // You can use Navigator to push/pop pages as needed
                print('Tapped on item $index');
              },
            );
          } else {
            return SizedBox(); // Return an empty SizedBox for landscape orientation
          }
        },
      ),
    );
  }

  Widget buildPortraitTimetable() {
    // Find the longest truncated subject name length
    int longestTruncatedSubjectLength = 0;
    for (String day in days) {
      for (String timeSlot in timetableData[day.toLowerCase()].keys) {
        String subjectName =
            timetableData[day.toLowerCase()][timeSlot]['course_name'];
        String truncatedSubjectName = _truncateSubjectName(subjectName);
        if (truncatedSubjectName.length > longestTruncatedSubjectLength) {
          longestTruncatedSubjectLength = truncatedSubjectName.length;
        }
      }
    }

    // Calculate the height for row separators based on the longest truncated subject name
    final double rowHeight =
        longestTruncatedSubjectLength * 10.0; // Adjust the multiplier as needed

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 10,
        horizontalMargin: 10,
        minWidth: 100,
        dataRowHeight: rowHeight,
        headingRowHeight: 40,
        columns: [
          DataColumn(label: Text('Day')),
          for (String timeSlot in timeSlots) DataColumn(label: Text(timeSlot)),
        ],
        rows: [
          for (String day in days)
            DataRow(
              cells: [
                DataCell(Text(day)),
                for (String timeSlot in timeSlots)
                  timetableData[day.toLowerCase()][timeSlot] != null
                      ? DataCell(
                          Text(
                            _truncateSubjectName(
                                timetableData[day.toLowerCase()][timeSlot]
                                        ?['course_name'] ??
                                    ""),
                            textAlign:
                                TextAlign.center, // Center align the text
                          ),
                        )
                      : DataCell(Text('')),
              ],
            ),
        ],
      ),
    );
  }

// Helper function to truncate subject names by taking only the first letter of each word

  Widget buildLandscapeTimetable() {
    // Find the longest truncated subject name length
    int longestTruncatedSubjectLength = 0;
    for (String day in days) {
      for (String timeSlot in timetableData[day.toLowerCase()].keys) {
        String subjectName =
            timetableData[day.toLowerCase()][timeSlot]['course_name'];
        String truncatedSubjectName = _truncateSubjectName(subjectName);
        if (truncatedSubjectName.length > longestTruncatedSubjectLength) {
          longestTruncatedSubjectLength = truncatedSubjectName.length;
        }
      }
    }

    // Calculate the height for row separators based on the longest truncated subject name
    final double rowHeight =
        longestTruncatedSubjectLength * 10.0; // Adjust the multiplier as needed

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DataTable2(
        columnSpacing: 10,
        horizontalMargin: 10,
        minWidth: 100,
        dataRowHeight: rowHeight,
        headingRowHeight: 40,
        columns: [
          DataColumn(label: Text('Day')),
          for (String timeSlot in timeSlots) DataColumn(label: Text(timeSlot)),
        ],
        rows: [
          for (String day in days)
            DataRow(
              cells: [
                DataCell(Text(day)),
                for (String timeSlot in timeSlots)
                  timetableData[day.toLowerCase()]?[timeSlot] != null
                      ? DataCell(
                          Text(
                            _truncateSubjectName(
                                timetableData[day.toLowerCase()][timeSlot]
                                        ?['course_name'] ??
                                    ""),
                            textAlign:
                                TextAlign.center, // Center align the text
                          ),
                        )
                      : DataCell(Text('')),
              ],
            ),
        ],
      ),
    );
  }

  String _truncateSubjectName(String subjectName) {
    List<String> words = subjectName.split(" ");
    String truncatedName = "";
    for (String word in words) {
      truncatedName += word.substring(0, 1);
    }
    return truncatedName;
  }
}
