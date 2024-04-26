import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'CGPA_calculator.dart';
import "package:college_connect/common/dio.config.dart";
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'sgpa_extractor.dart';

// void main() {
//   runApp(const MyApp());
// }

class Payment extends StatelessWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fee Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/paymentHome',
    );
  }
}

class Subject {
  final String name;
  final int fee;
  bool selected;

  Subject(this.name, this.fee, this.selected);
}

Future<void> _makeAnnoucement() async {
  try {
    final dioClient = DioClient();
    await dioClient.setAuthorizationHeader();

    final Response response =
        await dioClient.dio.get('api/faculty/send_email/');

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Email Sent to Parent Email Succesfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
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

class PaymentHome extends StatelessWidget {
  const PaymentHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FEE PAYMENT',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FloatingActionButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => CGPACalculator()),
          //     );
          //   },
          // ),
          // FloatingActionButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SGPAExtractor()),
          //     );
          //   },
          // ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  padding: EdgeInsets.symmetric(vertical: 48, horizontal: 0),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: List.generate(8, (index) {
                    final semester = index + 1;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SemesterPaymentScreen(semester: semester),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 4,
                        child: Center(
                          child: Text(
                            'SEMESTER $semester',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SemesterPaymentScreen extends StatefulWidget {
  final int semester;

  const SemesterPaymentScreen({Key? key, required this.semester})
      : super(key: key);

  @override
  State<SemesterPaymentScreen> createState() => _SemesterPaymentScreenState();
}

class _SemesterPaymentScreenState extends State<SemesterPaymentScreen> {
  late Razorpay _razorpay;
  late List<Subject> _subjects;
  int _totalFee = 0;
  bool _feesPaid = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _subjects = getSubjectsForSemester(widget.semester);
    _checkFeesPaid(); // Check if fees are already paid
  }

  void _checkFeesPaid() {
    _feesPaid =
        widget.semester != 7 && widget.semester != 8 && widget.semester != 1;
  }

  void _downloadReceipt(String type) {
    // Placeholder function to download receipt
    _makeAnnoucement();
    print('Downloading receipt for $type');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semester ${widget.semester} Payment'),
      ),
      body: _feesPaid ? _buildFeesPaidScreen() : _buildPaymentScreen(),
    );
  }

  Widget _buildFeesPaidScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SEMESTER ${widget.semester} Registration fee & exam fee is already paid.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _downloadReceipt('Registration Fees'),
            child: Text(
                'Download Receipt of SEM ${widget.semester} Registration Fees'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _downloadReceipt('Exam Fees'),
            child: Text('Download Receipt of SEM ${widget.semester} Exam Fees'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    _makeAnnoucement();
    _checkFeesPaid();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  Widget _buildPaymentScreen() {
    return Column(
      children: <Widget>[
        SizedBox(height: 24),
        Text(
          'SEMESTER ${widget.semester}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable(
            border: TableBorder.all(
                color: Color(0xFF000000),
                width: 1.0,
                style: BorderStyle.solid,
                borderRadius: BorderRadius.zero),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            columns: const <DataColumn>[
              DataColumn(label: Text('Subject')),
              DataColumn(label: Text('Fees')),
            ],
            rows: _subjects.map<DataRow>((subject) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(subject.name)),
                  DataCell(Text('Rs. ${subject.fee}')),
                ],
                selected: subject.selected,
                onSelectChanged: (bool? value) {
                  setState(() {
                    subject.selected = value!;
                    _updateTotalFee();
                  });
                },
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Total Fee: $_totalFee',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: _totalFee > 0 ? _payFees : null,
            child: Text('Pay Semester ${widget.semester} Fees'),
          ),
        ),
      ],
    );
  }

  void _updateTotalFee() {
    setState(() {
      _totalFee = 0;
      _subjects.forEach((subject) {
        if (subject.selected) {
          _totalFee += subject.fee;
        }
      });
    });
  }

  void _payFees() {
    var options = {
      'key': 'rzp_live_MkhFrOg5rYD4WF',
      'amount': _totalFee * 100, // Convert fee to paise
      'name': 'Goa college of Engineering',
      'order_id': '',
      'description': 'Semester Fees for SEM ${widget.semester}',
      'timeout': 120,
    };
    _razorpay.open(options);
  }

  List<Subject> getSubjectsForSemester(int semester) {
    // This is a placeholder function. You should replace it with your actual logic
    // to fetch subjects for each semester from your data source (e.g., a database or API).
    // For demonstration purposes, we'll return dummy data here.

    List<Subject> subjects = [];

    switch (semester) {
      case 1:
        subjects = [
          Subject('Maths I', 500, false),
          Subject('Basics of Electrical & Electronics Engineering', 700, false),
          Subject('Basics of Mechanical Engineering', 1000, false),
          Subject('Chemistry', 700, false),
          Subject('Physics', 700, false),
          Subject('Workshop I', 1000, false),
          Subject('Workshop II', 1000, false),
          Subject('Practical Lab I', 1000, false),
          Subject('Practical Lab II', 1000, false),
        ];
        break;
      case 2:
        subjects = [
          Subject('Subject 2A', 600, false),
          Subject('Subject 2B', 800, false),
          Subject('Subject 2C', 1100, false),
        ];
        break;
      case 3:
        subjects = [
          Subject('Maths I', 500, false),
          Subject('Basics of Electrical & Electronics Engineering', 700, false),
          Subject('Basics of Mechanical Engineering', 1000, false),
          Subject('Chemistry', 700, false),
          Subject('Physics', 700, false),
          Subject('Workshop I', 1000, false),
          Subject('Workshop II', 1000, false),
          Subject('Practical Lab I', 1000, false),
          Subject('Practical Lab II', 1000, false),
        ];
        break;
      case 4:
        subjects = [
          Subject('Maths I', 500, false),
          Subject('Basics of Electrical & Electronics Engineering', 700, false),
          Subject('Basics of Mechanical Engineering', 1000, false),
          Subject('Chemistry', 700, false),
          Subject('Physics', 700, false),
          Subject('Workshop I', 1000, false),
          Subject('Workshop II', 1000, false),
          Subject('Practical Lab I', 1000, false),
          Subject('Practical Lab II', 1000, false),
        ];
        break;
      case 5:
        subjects = [
          Subject('Maths I', 500, false),
          Subject('Basics of Electrical & Electronics Engineering', 700, false),
          Subject('Basics of Mechanical Engineering', 1000, false),
          Subject('Chemistry', 700, false),
          Subject('Physics', 700, false),
          Subject('Workshop I', 1000, false),
          Subject('Workshop II', 1000, false),
          Subject('Practical Lab I', 1000, false),
          Subject('Practical Lab II', 1000, false),
        ];
        break;
      case 6:
        subjects = [
          Subject('Maths I', 500, false),
          Subject('Basics of Electrical & Electronics Engineering', 700, false),
          Subject('Basics of Mechanical Engineering', 1000, false),
          Subject('Chemistry', 700, false),
          Subject('Physics', 700, false),
          Subject('Workshop I', 1000, false),
          Subject('Workshop II', 1000, false),
          Subject('Practical Lab I', 1000, false),
          Subject('Practical Lab II', 1000, false),
        ];
        break;
      case 7:
        subjects = [
          Subject('Image Processing ', 1200, false),
          Subject('PE 1 - Data Analytics ', 700, false),
          Subject('PE 1 - Genetic Algorithms', 700, false),
          Subject('Open Elective - SEM 7 ', 1000, false),
          Subject('Practical Lab', 500, false),
          Subject('Project Phase I', 500, false),
          Subject('Internship', 500, false),
        ];
        break;
      case 8:
        subjects = [
          Subject('Cryptography & Network Security', 1, false),
          Subject('PE 1 - Mobile Computing', 2, false),
          Subject('Project Phase II ', 3, false),
        ];
        break;
      // Add cases for other semesters
      default:
        subjects = [];
    }

    return subjects;
  }
}
