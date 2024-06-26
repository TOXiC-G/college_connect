import 'package:flutter/material.dart';

class FeedbackFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course End Feedback Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  List<int> _feedbackValues = List<int>.filled(4, 3);

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Process the feedback values
      print('Feedback submitted: $_feedbackValues');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course End Feedback Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Course Title: CRYPTOGRAPHY AND NETWORK SECURITY',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Department: INFORMATION TECHNOLOGY',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Semester: VIII',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Name of the Teacher: Ms. Siddhi P. Naik',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Please provide your feedback (3 = Max, 2 = Avg, 1 = Min):',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              _buildQuestion(1,
                  'Did the teacher put sufficient efforts to make you understand the basic concepts related to the course (CO1)?'),
              _buildQuestion(2,
                  'Do you feel that sufficient explanation examples of concepts co-relation to real world situation were given during teaching and in the laboratory (CO2)?'),
              _buildQuestion(3,
                  'After going through the course do you have confidence in selecting or recommending a particular algorithm for a given application (CO3)?'),
              _buildQuestion(4,
                  'After going through the course do you feel that you can develop basic application with security requirements (CO4)?'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(int number, String questionText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          '$number. $questionText',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RadioListTile<int>(
                title: Text('3'),
                value: 3,
                groupValue: _feedbackValues[number - 1],
                onChanged: (value) {
                  setState(() {
                    _feedbackValues[number - 1] = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: Text('2'),
                value: 2,
                groupValue: _feedbackValues[number - 1],
                onChanged: (value) {
                  setState(() {
                    _feedbackValues[number - 1] = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<int>(
                title: Text('1'),
                value: 1,
                groupValue: _feedbackValues[number - 1],
                onChanged: (value) {
                  setState(() {
                    _feedbackValues[number - 1] = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
