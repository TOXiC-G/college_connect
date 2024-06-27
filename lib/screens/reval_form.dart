import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pdf/pdf.dart';

void main() {
  runApp(RevaluationFormApp());
}

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
  final TextEditingController _seatNoController = TextEditingController();
  final TextEditingController _centerController = TextEditingController();
  final TextEditingController _examDateController = TextEditingController();

  String _selectedDepartment = 'IT';
  String _selectedSemester = '1';
  int _totalAmount = 0;
  String _paymentMethod = '';
  String _paymentId = '';
  DateTime? _paymentTime;

  List<Map<String, String>> subjects = [];
  int subjectCount = 0;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

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
      _totalAmount = subjectCount * 1;
    });
  }

  void _removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
      subjectCount--;
      _totalAmount = subjectCount * 1;
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
            department: _selectedDepartment,
            semester: _selectedSemester,
            seatNo: _seatNoController.text,
            center: _centerController.text,
            examDate: _examDateController.text,
            amount: _totalAmount.toString(),
            subjects: subjects,
            onFinalSubmit: _handleFinalSubmit,
          ),
        ),
      );
    }
  }

  void _handleFinalSubmit() {
    var options = {
      'key': 'rzp_live_MkhFrOg5rYD4WF',
      'amount': _totalAmount * 100, // in paise
      'name': 'GEC College',
      'description': 'Revaluation Fees',
      'timeout': 120,
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    _paymentMethod = 'Razorpay'; // Assuming payment method is Razorpay
    _paymentId =
        response.paymentId ?? ''; // Assign an empty string if paymentId is null
    _paymentTime = DateTime.now();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationPage(
          name: _nameController.text,
          prNumber: _prNumberController.text,
          department: _selectedDepartment,
          semester: _selectedSemester,
          seatNo: _seatNoController.text,
          center: _centerController.text,
          examDate: _examDateController.text,
          amount: _totalAmount.toString(),
          paymentMethod: _paymentMethod,
          paymentId: _paymentId,
          paymentTime: _paymentTime!,
          subjects: subjects,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet Payment Selected",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revaluation Form'),
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
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'IT',
                  'COMP',
                  'ETC',
                  'ENE',
                  'CIVIL',
                  'MECH',
                  'VLSI',
                  'ECOMP',
                ].map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSemester,
                decoration: InputDecoration(
                  labelText: 'Semester',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(8, (index) => (index + 1).toString())
                    .map((semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(semester),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _seatNoController,
                decoration: InputDecoration(
                  labelText: 'Seat Number',
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
                  labelText: 'Name of Center',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the center name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _examDateController,
                decoration: InputDecoration(
                  labelText: 'Month and Year of Examination',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the exam date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Subjects for Revaluation:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...subjects.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> subject = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subject ${index + 1}:'),
                    TextFormField(
                      initialValue: subject['name'],
                      decoration: InputDecoration(
                        labelText: 'Subject Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          subject['name'] = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: subject['code'],
                      decoration: InputDecoration(
                        labelText: 'Paper Code',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          subject['code'] = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: subject['paperName'],
                      decoration: InputDecoration(
                        labelText: 'Paper Name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          subject['paperName'] = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: subject['marksObtained'],
                      decoration: InputDecoration(
                        labelText: 'Marks Obtained',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          subject['marksObtained'] = value;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: subject['marksTotal'],
                      decoration: InputDecoration(
                        labelText: 'Total Marks',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          subject['marksTotal'] = value;
                        });
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addSubject,
                child: Text('Add Subject'),
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Text('Total Amount: $_totalAmount'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showPreview,
                child: Text('Preview & Pay'),
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
  final String department;
  final String semester;
  final String seatNo;
  final String center;
  final String examDate;
  final String amount;
  final List<Map<String, String>> subjects;
  final VoidCallback onFinalSubmit;

  PreviewPage({
    required this.name,
    required this.address,
    required this.prNumber,
    required this.department,
    required this.semester,
    required this.seatNo,
    required this.center,
    required this.examDate,
    required this.amount,
    required this.subjects,
    required this.onFinalSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview & Pay'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Please review the details below:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Name: $name'),
            Text('Address: $address'),
            Text('PR Number: $prNumber'),
            Text('Department: $department'),
            Text('Semester: $semester'),
            Text('Seat No.: $seatNo'),
            Text('Center: $center'),
            Text('Exam Date: $examDate'),
            Text('Amount: $amount'),
            SizedBox(height: 16),
            Text(
              'Subjects:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...subjects.map((subject) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject Name: ${subject['name']}'),
                  Text('Paper Code: ${subject['code']}'),
                  Text('Paper Name: ${subject['paperName']}'),
                  Text('Marks Obtained: ${subject['marksObtained']}'),
                  Text('Total Marks: ${subject['marksTotal']}'),
                  SizedBox(height: 8),
                ],
              );
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onFinalSubmit,
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final String name;
  final String prNumber;
  final String department;
  final String semester;
  final String seatNo;
  final String center;
  final String examDate;
  final String amount;
  final String paymentMethod;
  final String paymentId;
  final DateTime paymentTime;
  final List<Map<String, String>> subjects;

  ConfirmationPage({
    required this.name,
    required this.prNumber,
    required this.department,
    required this.semester,
    required this.seatNo,
    required this.center,
    required this.examDate,
    required this.amount,
    required this.paymentMethod,
    required this.paymentId,
    required this.paymentTime,
    required this.subjects,
  });

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('GEC College - Revaluation Form Receipt',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 16),
                pw.Text('Name: $name'),
                pw.Text('PR Number: $prNumber'),
                pw.Text('Department: $department'),
                pw.Text('Semester: $semester'),
                pw.Text('Seat No.: $seatNo'),
                pw.Text('Center: $center'),
                pw.Text('Exam Date: $examDate'),
                pw.Text('Amount: $amount'),
                pw.Text('Payment Method: $paymentMethod'),
                pw.Text('Payment ID: $paymentId'),
                pw.Text('Payment Time: ${paymentTime.toLocal()}'),
                pw.SizedBox(height: 16),
                pw.Text('Subjects:',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                ...subjects.map((subject) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Subject Name: ${subject['name']}'),
                      pw.Text('Paper Code: ${subject['code']}'),
                      pw.Text('Paper Name: ${subject['paperName']}'),
                      pw.Text('Marks Obtained: ${subject['marksObtained']}'),
                      pw.Text('Total Marks: ${subject['marksTotal']}'),
                      pw.SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Payment Successful!',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 16),
            Text('Name: $name'),
            Text('PR Number: $prNumber'),
            Text('Department: $department'),
            Text('Semester: $semester'),
            Text('Seat No.: $seatNo'),
            Text('Center: $center'),
            Text('Exam Date: $examDate'),
            Text('Amount: $amount'),
            Text('Payment Method: $paymentMethod'),
            Text('Payment ID: $paymentId'),
            Text('Payment Time: ${paymentTime.toLocal()}'),
            SizedBox(height: 16),
            Text(
              'Subjects:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...subjects.map((subject) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject Name: ${subject['name']}'),
                  Text('Paper Code: ${subject['code']}'),
                  Text('Paper Name: ${subject['paperName']}'),
                  Text('Marks Obtained: ${subject['marksObtained']}'),
                  Text('Total Marks: ${subject['marksTotal']}'),
                  SizedBox(height: 8),
                ],
              );
            }).toList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generatePDF,
              child: Text('Download PDF Receipt'),
            ),
            ElevatedButton(
              onPressed: () {
                // Functionality to view receipt can be implemented here
              },
              child: Text('View Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
