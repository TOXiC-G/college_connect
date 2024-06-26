import 'package:flutter/material.dart';

class SemesterFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semester Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SemesterFormPage(),
    );
  }
}

class SemesterFormPage extends StatefulWidget {
  @override
  _SemesterFormPageState createState() => _SemesterFormPageState();
}

class _SemesterFormPageState extends State<SemesterFormPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController prNumberController = TextEditingController();
  TextEditingController examYearController = TextEditingController();
  TextEditingController permissionMonthController = TextEditingController();
  String? selectedCollege;
  String? selectedDepartment;
  String? selectedGender;
  String? selectedCategory;
  String? selectedSemester;
  bool isRepeater = false;

  List<String> colleges = ['GEC', 'PCC', 'RIT', 'AITD', 'DBCE'];
  List<String> departments = [
    'Civil',
    'Mechanical',
    'Computer',
    'IT',
    'E&TC',
    'E&E',
    'E&C',
    'VLSI'
  ];
  List<String> genders = ['Male', 'Female'];
  List<String> categories = ['GEN', 'SC', 'ST', 'OBC'];
  List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Semester Exam Registration Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: rollNoController,
                  decoration: InputDecoration(
                    labelText: 'Roll No',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your roll number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: prNumberController,
                  decoration: InputDecoration(
                    labelText: 'PR Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your PR number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  items: genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'College and Department Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select College',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedCollege,
                  onChanged: (value) {
                    setState(() {
                      selectedCollege = value;
                    });
                  },
                  items: colleges.map((college) {
                    return DropdownMenuItem(
                      value: college,
                      child: Text(college),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a college';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Department',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDepartment,
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  items: departments.map((department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a department';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Semester',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSemester,
                  onChanged: (value) {
                    setState(() {
                      selectedSemester = value;
                    });
                  },
                  items: semesters.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Text('Semester $semester'),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a semester';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Exam Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: examYearController,
                  decoration: InputDecoration(
                    labelText: 'Exam Year',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter exam year';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: permissionMonthController,
                  decoration: InputDecoration(
                    labelText: 'Permission Month (e.g., December 2023)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the permission month';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Are you a repeater?'),
                    Checkbox(
                      value: isRepeater,
                      onChanged: (value) {
                        setState(() {
                          isRepeater = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                if (isRepeater) RepeaterDetailsSection(),
                ExamDetailsTable(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Form submitted successfully!')),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExamDetailsTable extends StatelessWidget {
  final List<String> subjects = [
    'Subject 1',
    'Subject 2',
    'Subject 3',
    'Subject 4',
    'Subject 5',
    'Subject 6',
  ];

  final List<String> examComponents = [
    'Theory',
    'Sessional',
    'Practical',
    'Term Work'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exam Components',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Table(
          border: TableBorder.all(),
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                TableCell(child: Center(child: Text('Subject'))),
                ...examComponents
                    .map((component) =>
                        TableCell(child: Center(child: Text(component))))
                    .toList(),
              ],
            ),
            ...subjects.map((subject) {
              return TableRow(
                children: [
                  TableCell(
                      child: Padding(
                          padding: EdgeInsets.all(8), child: Text(subject))),
                  ...examComponents.map((component) {
                    return TableCell(child: ExamComponentCheckbox());
                  }).toList(),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}

class ExamComponentCheckbox extends StatefulWidget {
  @override
  _ExamComponentCheckboxState createState() => _ExamComponentCheckboxState();
}

class _ExamComponentCheckboxState extends State<ExamComponentCheckbox> {
  String? selectedOption;

  void _onOptionTap() {
    setState(() {
      if (selectedOption == null) {
        selectedOption = 'A';
      } else if (selectedOption == 'A') {
        selectedOption = 'R';
      } else if (selectedOption == 'R') {
        selectedOption = 'E';
      } else {
        selectedOption = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onOptionTap,
      child: Container(
        height: 30,
        color: selectedOption != null ? Colors.blue : Colors.white,
        child: Center(
          child: Text(
            selectedOption ?? '',
            style: TextStyle(
                color: selectedOption != null ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class RepeaterDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeater Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Last Appearance Details',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter last appearance details';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Seat No.',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter seat number';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Year of Exam',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter year of exam';
            }
            return null;
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Simultaneously appearing for semester',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter details';
            }
            return null;
          },
        ),
      ],
    );
  }
}
