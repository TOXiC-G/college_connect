import 'package:college_connect/common/appbar.dart';
import 'package:college_connect/common/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class Submission {
  final String submissionId;
  final String submittedAt;
  final String student;
  final String graded;
  final String marks;
  final String remarks;
  final String attachment;
  final int totalMarks;

  Submission({
    required this.submissionId,
    required this.submittedAt,
    required this.student,
    required this.graded,
    required this.marks,
    required this.remarks,
    required this.attachment,
    required this.totalMarks,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      submissionId: json['submission_id'].toString(),
      submittedAt: json['submitted_at'].toString(),
      student: json['student'].toString(),
      marks: json['marks'].toString(),
      graded: json['graded'].toString(),
      remarks: json['remarks'].toString(),
      attachment: json['attachment'].toString(),
      totalMarks: int.parse(json['total_marks'].toString()),
    );
  }
}

class FacultySingleSubmission extends StatefulWidget {
  final String submissionId;

  FacultySingleSubmission({required this.submissionId});

  @override
  _FacultySingleSubmissionState createState() =>
      _FacultySingleSubmissionState();
}

class _FacultySingleSubmissionState extends State<FacultySingleSubmission> {
  String _remarks = '';
  int _marks = 0;
  Submission? submission;
  bool render = false;
  void initState() {
    super.initState();
    getSubmission();
  }

  Future<void> getSubmission() async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      final Response response = await dioClient.dio.post(
        'api/faculty/get_submission/',
        data: {
          'submission_id': widget.submissionId,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          submission = Submission.fromJson(response.data);
          render = true;
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed to get submission',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> handleSubmit() async {
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      if (_marks > submission!.totalMarks) {
        Fluttertoast.showToast(
          msg: 'Marks cannot be greater than total marks',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        print("MONKEY");
        return;
      }
      final Response response = await dioClient.dio.post(
        'api/faculty/evaluate_submission/',
        data: {
          'submission_id': widget.submissionId,
          'marks': _marks,
          'remarks': _remarks,
        },
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Submission graded successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed to grade submission',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Single Submission',
        automaticallyImplyLeading: true,
      ),
      body: render == true
          ? Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      ListTile(
                        title: Text('Submission ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(submission!.submissionId),
                      ),
                      ListTile(
                        title: Text('Submitted At',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(submission!.submittedAt),
                      ),
                      ListTile(
                        title: Text('Student',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(submission!.student),
                      ),
                      ListTile(
                        title: Text('Graded',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(submission!.graded),
                      ),
                      ListTile(
                        title: Text('Marks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: TextFormField(
                          initialValue: submission!.marks == 'null'
                              ? '0'
                              : submission!.marks,
                          onChanged: (value) {
                            if (int.parse(value) > submission!.totalMarks) {
                              Fluttertoast.showToast(
                                msg: 'Marks cannot be greater than total marks',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              setState(() {
                                _marks = int.parse(value);
                              });
                            } else {
                              setState(() {
                                _marks = int.parse(value);
                              });
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      ListTile(
                        title: Text('Remarks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: TextFormField(
                          initialValue: submission!.remarks == 'null'
                              ? ''
                              : submission!.remarks,
                          onChanged: (value) {
                            setState(() {
                              _remarks = value;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final dioClient = DioClient();
                          final url =
                              "${dioClient.dio.options.baseUrl}${submission!.attachment}";
                          if (!await launchUrl(Uri.parse(url))) {
                            throw 'Could not launch $submission.attachment';
                          }
                        },
                        child: Text('OPEN ATTACHMENT'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          handleSubmit();
                        },
                        child: Text('GRADE SUBMISSION'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : (Center(
              child: CircularProgressIndicator(),
            )),
      bottomNavigationBar: CommonBottomNavigationBar(
          currentIndex: 0, onItemSelected: (value) => {}),
    );
  }
}
