import 'package:college_connect/screens/Faculty/faculty_singleAssignment.dart';
import 'package:college_connect/screens/student_singleAssignment.dart';
import 'package:flutter/material.dart';
import '../common/navbar.dart';
import '../common/appbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Assignment {
  final String assignmentId;
  final String assignmentNo;
  final String dueDate;
  final String uploadedBy;
  final String course;
  final String? attachments;

  Assignment({
    required this.assignmentId,
    required this.assignmentNo,
    required this.dueDate,
    required this.uploadedBy,
    required this.course,
    this.attachments,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    print("HERE");
    return Assignment(
        assignmentId: json['assignment_id'].toString(),
        assignmentNo: json['assignment_no'].toString(),
        dueDate: json['due_date'].toString(),
        uploadedBy: json['uploaded_by'].toString(),
        course: json['course'].toString(),
        attachments: json['attachments'].toString());
  }
}

class AssignmentsPage extends StatefulWidget {
  @override
  AssignmentsPageState createState() => AssignmentsPageState();
}

class AssignmentsPageState extends State<AssignmentsPage> {
  @override
  void initState() {
    super.initState();
    getAssignments();
  }

  Map<String, List<Assignment>> assignmentList = {};
  Future<void> getAssignments() async {
    const secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      String? token = await secureStorage.read(key: 'accessToken');
      String tokenString = token.toString();
      dioClient.dio.options.headers['Authorization'] = 'Bearer $tokenString';
      final Response response = await dioClient.dio.post(
        '/api/student/get_assignments/',
        data: {
          'student_id': id,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        // Successful login
        Map<String, dynamic> assignmentDataMap = response.data;
        setState(() {
          assignmentList = assignmentDataMap.map((key, value) {
            // Convert the list of assignments to a list of Assignment objects
            List<Assignment> assignments = (value as List<dynamic>)
                .map((assignmentData) => Assignment.fromJson(assignmentData))
                .toList();
            return MapEntry(key, assignments);
          });
        });
        print(assignmentList);
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
    return Scaffold(
      appBar: CommonAppBar(
        title: 'ASSIGNMENTS',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search bar
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text(
                      'Search for...',
                      style: TextStyle(fontFamily: 'Jost'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Notifications
              for (String courseName in assignmentList.keys)
                if (assignmentList[courseName]!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseName,
                        style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      for (Assignment assignment in assignmentList[courseName]!)
                        _buildNotificationContainer(
                          assignment.assignmentId,
                          'Assignment ' + assignment.assignmentNo,
                          assignment.dueDate,
                          assignment.uploadedBy,
                          Colors.indigo,
                          assignment.course,
                        ),
                    ],
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0,
        onItemSelected: (index) {
          // Handle navigation to different pages
          // You can use Navigator to push/pop pages as needed
          print('Tapped on item $index');
        },
      ),
    );
  }

  Widget _buildPaymentDueContainer(
    String paymentName,
    String dueDate,
    String amountDue,
    String bgColor,
    String strokeColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(int.parse(bgColor.replaceAll("#", "0xFF"))),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(int.parse(strokeColor.replaceAll("#", "0xFF"))),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAttribute('PAYMENT NAME', paymentName),
          _buildAttribute('DUE ON', dueDate),
          _buildAttribute('AMOUNT DUE', amountDue),
        ],
      ),
    );
  }

  Widget _buildNotificationContainer(
    String assignmentId,
    String title,
    String dueDate,
    String uploadedBy,
    Color strokeColor,
    String courseId,
  ) {
    return GestureDetector(
      onTap: () {
        // Handle onTap event
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Student_singleAssignmentPage(
                      assignmentId: assignmentId,
                    )));
        print(courseId);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: strokeColor,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAttribute('TITLE', title),
            _buildAttribute('DUE ON', dueDate),
            _buildAttribute('UPLOADED BY', uploadedBy),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute(String attributeName, String attributeValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$attributeName:',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 16,
          ),
        ),
        SizedBox(width: 8), // Add some spacing between attribute name and value
        Flexible(
          child: Text(
            attributeValue,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AssignmentsPage(),
  ));
}
