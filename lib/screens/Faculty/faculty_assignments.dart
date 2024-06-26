import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../common/dio.config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class FacultyAssignmentsPage extends StatefulWidget {
  @override
  _FacultyAssignmentsPageState createState() => _FacultyAssignmentsPageState();
}

class _FacultyAssignmentsPageState extends State<FacultyAssignmentsPage> {
  DateTime? _submissionDate;
  String _selectedType = 'Assignment';
  int _assignmentNo = 1;
  List<Map<String, dynamic>> _questions = [];
  List _attachments = [];
  int _totalMarks = 0;

  final _questionTitleController = TextEditingController();
  final _marksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String selectedCourseId =
        ModalRoute.of(context)!.settings.arguments as String;
    print(selectedCourseId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Assignment/Test'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: ['Assignment', 'Test', 'IT']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Type'),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: '${_selectedType} No.'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _assignmentNo = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: selectDate,
                    child: Text(
                      _submissionDate != null
                          ? 'Selected Submission Date: ${DateFormat('yyyy-MM-dd').format(_submissionDate!)}'
                          : 'Submission Date not selected',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _addQuestion();
                    },
                    child: Text('Add Question'),
                  ),
                  SizedBox(height: 16),
                  if (_questions.isNotEmpty) ...[
                    Text(
                      'Assignment Summary',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    for (int i = 0; i < _questions.length; i++)
                      CollapsibleQuestionTile(
                        index: i + 1,
                        questionTitle: _questions[i]['title'],
                        questionMarks: _questions[i]['marks'],
                        onRemove: () {
                          setState(() {
                            num tempMark = _questions[i]['marks'];
                            _totalMarks -= tempMark.toInt();
                            _questions.removeAt(i);
                          });
                        },
                      ),
                    SizedBox(height: 8),
                    Text(
                      'Total Marks: $_totalMarks',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                  if (_attachments.isNotEmpty) ...[
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      List<PlatformFile> files =
                          await _attachFiles() as List<PlatformFile>;
                      setState(() {
                        _attachments.addAll(files);
                      });
                    },
                    child: Text('Attach Files'),
                  ),
                  SizedBox(height: 16),
                  if (_questions.isNotEmpty) ...[
                    ElevatedButton(
                      onPressed: () {
                        // Handle send button
                        _sendAssignment(selectedCourseId);
                      },
                      child: Text('Send'),
                    ),
                  ],
                ],
              ),
            ),
          )),
    );
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionTitleController,
              decoration: InputDecoration(labelText: 'Question Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _marksController,
              decoration: InputDecoration(labelText: 'Marks Allotted'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              int marks = int.tryParse(_marksController.text) ?? 0;
              setState(() {
                _questions.add({
                  'title': _questionTitleController.text,
                  'marks': marks,
                });
                _totalMarks += marks;
              });
              _questionTitleController.clear();
              _marksController.clear();
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _submissionDate ??
          DateTime.now(), // Use current date if _submissionDate is null
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _submissionDate) {
      setState(() {
        _submissionDate = pickedDate;
      });
    }
  }

  Future<List> _attachFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
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

  Future<void> _sendAssignment(String selectedCourseId) async {
    // Prepare assignment data
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    const secureStorage = FlutterSecureStorage();
    String? id = await secureStorage.read(key: 'id');
    try {
      final dioClient = DioClient();
      await dioClient.setAuthorizationHeader();
      var formData = FormData.fromMap({
        'sender': id.toString(),
        'course_id': selectedCourseId.toString(),
        'type': _selectedType.toString(),
        'assignment_no': _assignmentNo.toString(),
        'submission_date': formatter.format(_submissionDate!).toString(),
        'questions': jsonEncode(_questions),
        'total_marks': _totalMarks.toString(),
      });

      for (var attachment in _attachments) {
        formData.files.addAll([
          MapEntry(
            'attachments',
            await MultipartFile.fromFile(
              attachment.path,
              filename: attachment.name,
            ),
          ),
        ]);
      }

      print(formData.fields);
      dioClient.dio.options.headers['content-Type'] = 'multipart/form-data';
      dioClient.dio.options.headers['Accept'] = 'application/json';

      final Response response = await dioClient.dio
          .post('api/faculty/make_assignment/', data: formData);

      if (response.statusCode == 200) {
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

    // Send assignment data to the backend
    // Replace this with your API call
  }

  @override
  void dispose() {
    _questionTitleController.dispose();
    _marksController.dispose();
    super.dispose();
  }
}

class CollapsibleQuestionTile extends StatefulWidget {
  final int index;
  final String questionTitle;
  final int questionMarks;
  final VoidCallback onRemove;

  const CollapsibleQuestionTile({
    required this.index,
    required this.questionTitle,
    required this.questionMarks,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  _CollapsibleQuestionTileState createState() =>
      _CollapsibleQuestionTileState();
}

class _CollapsibleQuestionTileState extends State<CollapsibleQuestionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text('Question ${widget.index}'),
            subtitle: _expanded ? Text(widget.questionTitle) : null,
            trailing: InkWell(
              onTap: widget.onRemove,
              child: Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Text(
                'Marks: ${widget.questionMarks}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FacultyAssignmentsPage(),
  ));
}
