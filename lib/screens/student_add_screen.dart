import 'package:flutter/material.dart';
import 'package:student_crud/models/student.dart';
import 'package:student_crud/services/student_service.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final StudentService _studentService = StudentService();

  String _firstName = '';
  String _lastName = '';
  String _course = '';
  String _year = 'First Year';
  bool _enrolled = false;

  List<String> years = [
    'First Year',
    'Second Year',
    'Third Year',
    'Fourth Year',
    'Fifth Year'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'First Name',
                onChanged: (value) => setState(() => _firstName = value),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a first name' : null,
                helperText: 'Enter the student\'s first name',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Last Name',
                onChanged: (value) => setState(() => _lastName = value),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a last name' : null,
                helperText: 'Enter the student\'s last name',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Course',
                onChanged: (value) => setState(() => _course = value),
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a course' : null,
                helperText: 'Enter the course the student is enrolled in',
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _year,
                onChanged: (String? newValue) {
                  setState(() {
                    _year = newValue!;
                  });
                },
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (bool value) {
                  setState(() {
                    _enrolled = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add Student',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    required FormFieldValidator<String> validator,
    String? helperText,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        helperText: helperText,
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newStudent = Student(
        id: '',
        firstName: _firstName,
        lastName: _lastName,
        course: _course,
        year: _year,
        enrolled: _enrolled,
      );

      try {
        await _studentService.createStudent(newStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student added successfully')),
        );
        Navigator.pop(context, true); // Refresh previous screen
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}




