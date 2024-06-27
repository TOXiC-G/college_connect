import 'package:college_connect/common/appbar.dart';
import 'package:college_connect/screens/Faculty/faculty_singleAssignment.dart';
import 'package:college_connect/screens/Faculty/faculty_singleITPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../common/dio.config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/navbar.dart';
import '../../common/appbar.dart';

class Submission {
  final bool graded;
  final String marks;

  Submission({
    required this.graded,
    required this.marks,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      marks: json['marks'].toString(),
      graded: json['graded'],
    );
  }
}

class Assignment {
  final String assignmentId;
  final String type;
  final String assignmentNo;
  final String questionCount;
  final String totalMarks;
  final String date;
  final String submissionDate;
  final Submission? submission;

  Assignment({
    required this.assignmentId,
    required this.type,
    required this.assignmentNo,
    required this.questionCount,
    required this.totalMarks,
    required this.date,
    required this.submissionDate,
    this.submission,
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
      submission: json.containsKey('submission')
          ? Submission.fromJson(json['submission'])
          : null,
    );
  }
}

class StudentSelectMarksPage extends StatefulWidget {
  final String courseId;
  const StudentSelectMarksPage({Key? key, required this.courseId})
      : super(key: key);
  @override
  _StudentSelectMarksPageState createState() => _StudentSelectMarksPageState();
}

class _StudentSelectMarksPageState extends State<StudentSelectMarksPage> {
  late Future<List<Assignment>>? _futureAssignments;
  String? selectedCourseId;

  @override
  void initState() {
    super.initState();
    // print("HI");
    selectedCourseId = widget.courseId;
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
        'api/student/get_all_assignments/',
        data: {
          'student_id': id,
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
                              child: Card(
                            surfaceTintColor: Colors.transparent,
                            margin: EdgeInsets.only(top: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: assignment.submission != null &&
                                              assignment.submission!.graded
                                          ? Colors.green
                                          : Colors.indigo.shade800,
                                      width: 1), // Border color
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text(
                                  '${assignment.type}: ${assignment.assignmentNo}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Total marks: ${assignment.totalMarks}'),
                                    if (assignment.submission != null)
                                      if (assignment.submission!.graded)
                                        Text(
                                            'Your Marks: ${assignment.submission!.marks}'),
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
