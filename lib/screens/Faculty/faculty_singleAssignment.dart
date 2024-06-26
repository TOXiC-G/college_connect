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

class Question {
  final String title;
  final String marks;

  Question({required this.title, required this.marks});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      title: json['title'].toString(),
      marks: json['marks'].toString(),
    );
  }
}

class Assignment {
  final String assignmentNo;
  final String totalMarks;
  final String type;
  final String submissionDate;
  final String date;
  final List<Question> questions;
  final String? attachments;

  Assignment({
    required this.assignmentNo,
    required this.totalMarks,
    required this.type,
    required this.submissionDate,
    required this.date,
    required this.questions,
    this.attachments,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      assignmentNo: json['a_no'].toString(),
      totalMarks: json['total_marks'].toString(),
      type: json['type'].toString(),
      submissionDate: json['submission_date'].toString(),
      date: json['date'].toString(),
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
      attachments:
          json['attachments'] == null ? null : json['attachments'].toString(),
    );
  }
}

class Submission {
  final String submissionId;
  final String student;
  final String marks;
  final String submittedAt;
  final String status;
  final String attachment;

  Submission({
    required this.submissionId,
    required this.student,
    required this.marks,
    required this.submittedAt,
    required this.status,
    required this.attachment,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submissionId: json['submission_id'].toString(),
      student: json['student'].toString(),
      marks: json['marks'].toString(),
      submittedAt: json['submitted_at'].toString(),
      status: json['graded'].toString(),
      attachment: json['attachment'].toString(),
    );
  }
}

class FacultySingleAssignmentPage extends StatefulWidget {
  @override
  _FacultySingleAssignmentPageState createState() =>
      _FacultySingleAssignmentPageState();

  final String assignmentId; // New parameter to hold the
  const FacultySingleAssignmentPage({
    Key? key,
    required this.assignmentId, // Receive assignmentId as a parameter
  }) : super(key: key);
}

class _FacultySingleAssignmentPageState
    extends State<FacultySingleAssignmentPage> {
  late String assignmentId;
  late Assignment assignment;
  late List<Submission> submissions;
  bool render = false;

  void initState() {
    super.initState();
    assignmentId = widget.assignmentId;
    getSingleAssignment(assignmentId);
  }

  Future<void> getSingleAssignment(String assignmentId) async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/faculty/get_single_assignment/',
        data: {
          'assignment_id': assignmentId,
        },
      );

      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          assignment = Assignment.fromJson(response.data);
          submissions = (response.data['submissions'] as List)
              .map((submission) => Submission.fromJson(submission))
              .toList();
        });
        render = true;
        print(assignment);
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

  @override
  Widget build(BuildContext context) {
    if (render) {
      return Scaffold(
        appBar: CommonAppBar(title: 'Single Assignment'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Assignment No: ${assignment.assignmentNo}'),
              Text('Total Marks: ${assignment.totalMarks}'),
              Text('Type: ${assignment.type}'),
              Text('Submission Date: ${assignment.submissionDate}'),
              Text('Date: ${assignment.date}'),
              Text('Questions:'),
              Column(
                children: assignment.questions
                    .map((question) => Column(
                          children: [
                            Text('Title: ${question.title}'),
                            Text('Marks: ${question.marks}'),
                          ],
                        ))
                    .toList(),
              ),
              if (assignment.attachments != null)
                Column(
                  children: [
                    Text('Attachment:'),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            child: InkWell(
                              onTap: () async {
                                final dioClient = DioClient();
                                print(
                                    '${dioClient.dio.options.baseUrl}${assignment.attachments!}');
                                if (assignment.attachments != null &&
                                    !await launchUrl(Uri.parse(
                                        '${dioClient.dio.options.baseUrl}${assignment.attachments!}'))) {
                                  throw 'Could not launch $assignment.attachments';
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Open Attachment'),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              Text(
                'Submissions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              _buildSubmissionCards(),
            ])),
        bottomNavigationBar: CommonBottomNavigationBar(
          // Add your navigation items here
          currentIndex: 0, // Set the current index accordingly
          onItemSelected: (index) {
            // Handle navigation to other pages
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: CommonAppBar(title: 'Single Assignment'),
        body: Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: CommonBottomNavigationBar(
            currentIndex: 0, onItemSelected: (value) => {}),
      );
    }
  }

  Widget _buildSubmissionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: submissions
          .map((submission) => Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacultySingleSubmission(
                        submissionId: submission.submissionId,
                      ),
                    ),
                  )
                },
                child: Card(
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: submission.status == 'true'
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
                          Text('Student: ${submission.student}'),
                          Text('Marks: ${submission.marks}'),
                          Text(
                              'Submitted On: ${DateFormat('dd-MM-yyyy @ HH:mm').format(DateTime.parse(submission.submittedAt))}'),
                        ],
                      )),
                ),
              )))
          .toList(),
    );
  }
}
