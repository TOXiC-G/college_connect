import 'package:flutter/material.dart';
// import '../common/navbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../common/navbar.dart';
import '../common/appbar.dart';
import '../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Question {
  final String question;
  final String marks;

  Question({required this.question, required this.marks});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'].toString(),
      marks: json['marks'].toString(),
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
  final List<Question> questions;
  final String? attachments;

  Assignment({
    required this.assignmentId,
    required this.type,
    required this.assignmentNo,
    required this.questionCount,
    required this.totalMarks,
    required this.date,
    required this.submissionDate,
    required this.questions,
    this.attachments,
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
      questions: (json['questions'] as List)
          .map((question) => Question.fromJson(question))
          .toList(),
      attachments:
          json['attachments'] == null ? null : json['attachments'].toString(),
    );
  }
}

class Student_singleAssignmentPage extends StatefulWidget {
  @override
  _Student_singleAssignmentState createState() =>
      _Student_singleAssignmentState();

  final String assignmentId;
  Student_singleAssignmentPage({required this.assignmentId});
}

class _Student_singleAssignmentState
    extends State<Student_singleAssignmentPage> {
  List _attachments = [];
  late Assignment assignment;
  late String assignmentId;
  bool render = false;
  void initState() {
    super.initState();
    assignmentId = widget.assignmentId;
    getAssignment(assignmentId);
  }

  Future<void> getAssignment(String assignmentId) async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/student/get_single_assignment/',
        data: {
          'assignment_id': assignmentId,
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
        Assignment temp = Assignment(
          assignmentId: response.data['assignment_id'].toString(),
          type: response.data['type'].toString(),
          assignmentNo: response.data['assignment_no'].toString(),
          questionCount: response.data['question_count'].toString(),
          totalMarks: response.data['total_marks'].toString(),
          date: response.data['date'].toString(),
          submissionDate: response.data['submission_date'].toString(),
          attachments: response.data['attachments'] == null
              ? null
              : response.data['attachments'].toString(),
          questions: (response.data['questions'] as List)
              .map((question) => Question.fromJson(question))
              .toList(),
        );
        setState(() => assignment = temp);
        setState(() => render = true);
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch notifications',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Assignment',
        automaticallyImplyLeading: true,
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: render
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Assignment No: ${assignment.assignmentNo}'),
                Text('Total Marks: ${assignment.totalMarks}'),
                Text('Type: ${assignment.type}'),
                Text('Submission Date: ${assignment.submissionDate}'),
                // Text('Date: ${assignment.date}'),
                Text('Questions:'),
                Column(
                  children: assignment.questions
                      .map((question) => Column(
                            children: [
                              Text('Title: ${question.question}'),
                              Text('Marks: ${question.marks}'),
                            ],
                          ))
                      .toList(),
                ),
                if (assignment.attachments != null)
                  Column(
                    children: [
                      Text('Attachment:'),
                      Column(children: [
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
                        ElevatedButton(
                            onPressed: () async {
                              List<PlatformFile> files =
                                  await _attachFiles() as List<PlatformFile>;
                              setState(() {
                                _attachments.addAll(files);
                              });
                            },
                            child: Text('Attach Assignment')),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Attached Files',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        for (var attachment in _attachments)
                          ListTile(
                            leading: Icon(Icons.attachment),
                            title: Text(
                              // attachment.toString().split('/').last,
                              attachment.name,
                              // attachment.path.split('/').last,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  _attachments.remove(attachment);
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                            // You can add onTap handler to open the file or perform any action
                          ),
                        ElevatedButton(
                            onPressed: () {
                              submitAssignment();
                            },
                            child: Text('Submit Assignment')),
                      ]),
                    ],
                  ),
              ])
            : CircularProgressIndicator(),
      )),
      // bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 1),
    );
  }

  Future<List> _attachFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          withData: true,
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'docx',
            'doc',
            'txt',
            'jpg',
            'jpeg',
            'png',
            'heic'
          ]);
      if (result != null) {
        // List<File> files = result.paths.map((path) => File(path!)).toList();
        List<PlatformFile> platformFiles = result.files;
        print(platformFiles[0].bytes);
        return platformFiles;
      } else {
        print('User canceled file picking');
        return [];
      }
    } catch (e) {
      print('Error picking files: $e');
      return [];
    }
  }

  Future<void> submitAssignment() async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();
      final String? studentId = await secureStorage.read(key: 'id');
      final formData = FormData.fromMap({
        'assignment_id': assignmentId,
        'student_id': studentId,
        'attachments': _attachments
            .map((file) => MultipartFile.fromBytes(
                  file.bytes!,
                  filename: file.name,
                ))
            .toList(),
      });
      final Response response = await dioClient.dio.post(
        'api/student/submit_assignment/',
        data: formData,
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Assignment submitted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to submit assignment',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print(e);
    }
  }
}
