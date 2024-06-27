import 'package:flutter/material.dart';
import 'package:college_connect/common/appbar.dart';

class RevaluationFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GEC College Revaluation Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RevaluationFormPage(),
    );
  }
}

class RevaluationFormPage extends StatefulWidget {
  @override
  _RevaluationFormPageState createState() => _RevaluationFormPageState();
}

class _RevaluationFormPageState extends State<RevaluationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _prNumberController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _seatNoController = TextEditingController();
  final TextEditingController _centerController = TextEditingController();
  final TextEditingController _examDateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionNumberController =
      TextEditingController();
  final TextEditingController _transactionDateController =
      TextEditingController();

  List<Map<String, String>> subjects = [];
  int subjectCount = 0;

  void _addSubject() {
    setState(() {
      subjects.add({
        'name': '',
        'code': '',
        'paperName': '',
        'marksObtained': '',
        'marksTotal': ''
      });
      subjectCount++;
    });
  }

  void _removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
      subjectCount--;
    });
  }

  void _showPreview() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            name: _nameController.text,
            address: _addressController.text,
            prNumber: _prNumberController.text,
            branch: _branchController.text,
            semester: _semesterController.text,
            seatNo: _seatNoController.text,
            center: _centerController.text,
            examDate: _examDateController.text,
            amount: _amountController.text,
            transactionNumber: _transactionNumberController.text,
            transactionDate: _transactionDateController.text,
            subjects: subjects,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Revaluation Form',
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'GOA UNIVERSITY\nAPPLICATION FOR REVALUATION OF ANSWER BOOKS',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Full Address for Communication',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _prNumberController,
                decoration: InputDecoration(
                  labelText: 'Permanent Registration No.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your PR number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _branchController,
                decoration: InputDecoration(
                  labelText: 'Branch',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your branch';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _semesterController,
                decoration: InputDecoration(
                  labelText: 'Semester',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your semester';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _seatNoController,
                decoration: InputDecoration(
                  labelText: 'Seat No.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your seat number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _centerController,
                decoration: InputDecoration(
                  labelText: 'Center',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your center';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _examDateController,
                decoration: InputDecoration(
                  labelText: 'Month & Year of Examination',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the examination date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Subjects ($subjectCount)'),
              ...subjects.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> subject = entry.value;
                return Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Subject Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        subject['name'] = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Paper Code',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        subject['code'] = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Paper Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        subject['paperName'] = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Marks Obtained',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        subject['marksObtained'] = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Marks Total',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        subject['marksTotal'] = value;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _removeSubject(index),
                      child: Text('Remove Subject'),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addSubject,
                child: Text('Add Subject'),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _transactionNumberController,
                decoration: InputDecoration(
                  labelText: 'SBI Collect Transaction No.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the transaction number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _transactionDateController,
                decoration: InputDecoration(
                  labelText: 'SBI Collect Date',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the transaction date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showPreview,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreviewPage extends StatelessWidget {
  final String name;
  final String address;
  final String prNumber;
  final String branch;
  final String semester;
  final String seatNo;
  final String center;
  final String examDate;
  final String amount;
  final String transactionNumber;
  final String transactionDate;
  final List<Map<String, String>> subjects;

  PreviewPage({
    required this.name,
    required this.address,
    required this.prNumber,
    required this.branch,
    required this.semester,
    required this.seatNo,
    required this.center,
    required this.examDate,
    required this.amount,
    required this.transactionNumber,
    required this.transactionDate,
    required this.subjects,
  });

  void _finalSubmit(BuildContext context) {
    // Add your submission logic here
    // After submission, you can navigate to another screen or show a success message
    Navigator.popUntil(context, (route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form Submitted Successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Preview Your Details',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildDetailRow('Name', name),
            _buildDetailRow('Address', address),
            _buildDetailRow('PR Number', prNumber),
            _buildDetailRow('Branch', branch),
            _buildDetailRow('Semester', semester),
            _buildDetailRow('Seat No.', seatNo),
            _buildDetailRow('Center', center),
            _buildDetailRow('Exam Date', examDate),
            _buildDetailRow('Amount', amount),
            _buildDetailRow('Transaction No.', transactionNumber),
            _buildDetailRow('Transaction Date', transactionDate),
            SizedBox(height: 16),
            Text('Subjects', style: TextStyle(fontWeight: FontWeight.bold)),
            ...subjects.map((subject) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Subject Name', subject['name'] ?? ''),
                  _buildDetailRow('Paper Code', subject['code'] ?? ''),
                  _buildDetailRow('Paper Name', subject['paperName'] ?? ''),
                  _buildDetailRow(
                      'Marks Obtained', subject['marksObtained'] ?? ''),
                  _buildDetailRow('Marks Total', subject['marksTotal'] ?? ''),
                  Divider(),
                ],
              );
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _finalSubmit(context),
              child: Text('Final Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
