// Import necessary packages
import 'package:flutter/material.dart';
import '../common/navbar.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Placeholder for fetched attendance data
  List<int> presentDates = [5, 10, 15, 20, 25]; // Replace with actual data

  // Placeholder for selected course in dropdown
  String? selectedCourse;

  // Placeholder for current month
  DateTime selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'ATTENDANCE',
          style: TextStyle(color: Color(0xFF202244), fontFamily: 'Jost'),
        ),
      ),
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
                        // Replace the comment with your API call for course-specific data
                      },
                      items: <String>['Course A', 'Course B', 'Course C']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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
              onDaySelected: (selectedDay, focusedDay) {
                // Replace the comment with your API call for fetching attendance data
                // Check if the selected day is present, and highlight accordingly
                if (presentDates.contains(selectedDay.day)) {
                  // Day is present, highlight in green
                  print('Day $selectedDay is present!');
                } else {
                  // Day is not present
                  print('Day $selectedDay is not present.');
                }
              },
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
