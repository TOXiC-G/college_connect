import 'package:college_connect/common/appbar.dart';
import 'package:college_connect/screens/Faculty/faculty_singleAssignment.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../common/dio.config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';

class Assignment {
  final String assignmentId;
  final String type;
  final String assignmentNo;
  final String questionCount;
  final String totalMarks;
  final String date;
  final String submissionDate;

  Assignment({
    required this.assignmentId,
    required this.type,
    required this.assignmentNo,
    required this.questionCount,
    required this.totalMarks,
    required this.date,
    required this.submissionDate,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      assignmentId: json['assignment_id'].toString(),
      type: json['type'].toString(),
      assignmentNo: json['a_no'].toString(),
      questionCount: json['question_count'].toString(),
      totalMarks: json['total_marks'].toString(),
      date: json['date'].toString(),
      submissionDate: json['submission_date'].toString(),
    );
  }
}

class FacultyGetAssignmentsPage extends StatefulWidget {
  final Function fetchCourseId;
  const FacultyGetAssignmentsPage({Key? key, required this.fetchCourseId})
      : super(key: key);
  @override
  _FacultyGetAssignmentsPageState createState() =>
      _FacultyGetAssignmentsPageState();
}

class _FacultyGetAssignmentsPageState extends State<FacultyGetAssignmentsPage> {
  late Future<List<Assignment>>? _futureAssignments;
  String? selectedCourseId;

  @override
  void initState() {
    super.initState();
    // print("HI");
    selectedCourseId = widget.fetchCourseId();
    _futureAssignments =
        _fetchAssignments(selectedCourseId); // Call after data is available
    // print("I");
  }

  Future<List<Assignment>> _fetchAssignments(String? selectedCourseId) async {
    // Change the return type to void
    // print("YUH IM WORKING");
    final secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/faculty/get_assignments/',
        data: {
          'faculty_id': id,
          'course_id': selectedCourseId,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        late Future<List<Assignment>>? assignments;
        assignments = Future.value(
          (response.data as List<dynamic>)
              .map((assignmentData) => Assignment.fromJson(assignmentData))
              .toList(),
        );
        return assignments;
      }
      if (response.statusCode == 204) return [];
      return [];
      // setState(() {
      //   _futureAssignments = Future.value(
      //       assignments); // Update _futureAssignments with the fetched assignments
      // });
    } catch (e) {
      print('Error fetching assignments: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Assignments',
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/facultyAssignments');
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF0961F5), // Background color
                onPrimary: Colors.white, // Text color
                padding: EdgeInsets.symmetric(vertical: 15), // Larger size
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Assignment/Test'),
                  Icon(Icons.arrow_forward, size: 18), // Arrow icon
                ],
              ),
            ),
            if (selectedCourseId == null || _futureAssignments == null)
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: FutureBuilder<List<Assignment>>(
                  future: _futureAssignments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No assignments found'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final assignment = snapshot.data![index];
                          return GestureDetector(
                              onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FacultySingleAssignmentPage(
                                          assignmentId: assignment.assignmentId,
                                        ),
                                      ),
                                    )
                                  },
                              child: Card(
                                surfaceTintColor: Colors.transparent,
                                margin: EdgeInsets.only(top: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.indigo.shade800,
                                          width: 1), // Border color
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    title: Text(
                                      '${assignment.type}: ${assignment.assignmentNo}',
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Questions: ${assignment.questionCount}'),
                                        Text(
                                            'Total marks: ${assignment.totalMarks}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: 0,
        onItemSelected: (index) {
          print('Tapped on item $index');
        },
      ),
    );
  }
}
