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

class Submission {
  final String submittedAt;
  final String graded;
  final String marks;
  final String remarks;
  final String attachment;

  Submission({
    required this.submittedAt,
    required this.graded,
    required this.marks,
    required this.remarks,
    required this.attachment,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submittedAt: json['submitted_at'].toString(),
      marks: json['marks'].toString(),
      graded: json['graded'].toString(),
      remarks: json['remarks'].toString(),
      attachment: json['attachment'].toString(),
    );
  }
}

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
  final Submission? submission;

  Assignment({
    required this.assignmentId,
    required this.type,
    required this.assignmentNo,
    required this.questionCount,
    required this.totalMarks,
    required this.date,
    required this.submissionDate,
    required this.questions,
    required this.submission,
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
      submission: Submission.fromJson(json['submission']),
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
      final storage = FlutterSecureStorage();
      final id = await storage.read(key: 'id');
      final Response response = await dioClient.dio.post(
        'api/student/get_single_assignment/',
        data: {
          'assignment_id': assignmentId,
          'student_id': id,
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
          submission: response.data['submission'] == null
              ? null
              : Submission.fromJson(response.data['submission']),
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
      body: SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: render
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Assignment No:', style: TextStyle(fontSize: 18)),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('${assignment.assignmentNo}',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                ),

                Text('Total Marks:', style: TextStyle(fontSize: 18)),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('${assignment.totalMarks}',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                ),
                if (assignment.submission != null)
                  if (assignment.submission!.graded == 'true')
                    Text('Marks Awarded:', style: TextStyle(fontSize: 18)),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('${assignment.submission!.marks}',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                ),
                Text('Type:', style: TextStyle(fontSize: 18)),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('${assignment.type}',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                ),

                Text('Submission Date:', style: TextStyle(fontSize: 18)),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                      '${DateFormat('dd-MM-yy').format(DateTime.parse(assignment.submissionDate))}',
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
                ),

                // Text('Date: ${assignment.date}'),
                Text(
                  'Questions:',
                  style: TextStyle(fontSize: 18),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: assignment.questions
                      .map((question) => Card(
                            surfaceTintColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Title: ${question.question}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 8.0, bottom: 8.0),
                                    child: Text('Marks: ${question.marks}'),
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.blue.shade800),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ))
                      .toList(),
                ),
                if (assignment.attachments != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child:
                            Text('Attachment:', style: TextStyle(fontSize: 18)),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (assignment.attachments != null)
                              ListTile(
                                onTap: () async {
                                  final dioClient = DioClient();
                                  if (assignment.attachments != null &&
                                      !await launchUrl(Uri.parse(
                                          '${dioClient.dio.options.baseUrl}${assignment.attachments!}'))) {
                                    throw 'Could not launch $assignment.attachments';
                                  }
                                },
                                leading: Icon(Icons.attachment),
                                title:
                                    Text(assignment.attachments!.split('/')[3]),
                                // You can add onTap handler to open the file or perform any action
                              ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF0961F5), // Background color
                                onPrimary: Colors.white, // Text color
                                padding: EdgeInsets.symmetric(
                                    vertical: 15), // Larger size
                              ),
                              onPressed: () async {
                                List<PlatformFile> files =
                                    await _attachFiles() as List<PlatformFile>;
                                setState(() {
                                  _attachments.addAll(files);
                                });
                              },
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text('Attach Assignment')),
                            ),
                            if (_attachments.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Current Attachment',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                            if (assignment.submission != null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Your Submissions',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (assignment.submission != null)
                              ListTile(
                                onTap: () async {
                                  final dioClient = DioClient();
                                  if (assignment.submission!.attachment !=
                                          null &&
                                      !await launchUrl(Uri.parse(
                                          '${dioClient.dio.options.baseUrl}${assignment.submission!.attachment}'))) {
                                    throw 'Could not launch $assignment.submission!.attachments';
                                  }
                                },
                                leading: Icon(Icons.attachment),
                                title: Text(assignment.submission!.attachment
                                    .split('/')[4]),
                                // You can add onTap handler to open the file or perform any action
                              ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(
                                      255, 1, 146, 13), // Background color
                                  onPrimary: Colors.white, // Text color
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15), // Larger size
                                ),
                                onPressed: () {
                                  submitAssignment();
                                },
                                child: Text('Submit Assignment')),
                          ]),
                    ],
                  ),
              ])
            : CircularProgressIndicator(),
      ))),
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
