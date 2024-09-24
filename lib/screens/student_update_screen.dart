import 'package:flutter/material.dart';
import 'package:student_crud/models/student.dart';
import 'package:student_crud/services/student_service.dart';

class UpdateStudentScreen extends StatefulWidget {
  final Student student;

  const UpdateStudentScreen({super.key, required this.student});

  @override
  _UpdateStudentScreenState createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController courseController;
  String selectedYear = 'First Year';
  bool isEnrolled = false;

  final StudentService _studentService = StudentService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.student.firstName);
    lastNameController = TextEditingController(text: widget.student.lastName);
    courseController = TextEditingController(text: widget.student.course);
    selectedYear = widget.student.year;
    isEnrolled = widget.student.enrolled;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Student'),
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
                'Update Student Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: firstNameController,
                label: 'First Name',
                validator: (value) => value?.isEmpty == true ? 'Please enter a first name' : null,
                helperText: 'Enter the student\'s first name',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: lastNameController,
                label: 'Last Name',
                validator: (value) => value?.isEmpty == true ? 'Please enter a last name' : null,
                helperText: 'Enter the student\'s last name',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                controller: courseController,
                label: 'Course',
                validator: (value) => value?.isEmpty == true ? 'Please enter a course' : null,
                helperText: 'Enter the course the student is enrolled in',
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                },
                items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                    .map<DropdownMenuItem<String>>((String value) {
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
                value: isEnrolled,
                onChanged: (bool value) {
                  setState(() {
                    isEnrolled = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _updateStudent,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Update Student',
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
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
    String? helperText,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: validator,
    );
  }

  void _updateStudent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedStudent = Student(
        id: widget.student.id, // Ensure this ID is correctly passed
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        course: courseController.text,
        year: selectedYear,
        enrolled: isEnrolled,
      );

      try {
        await _studentService.updateStudent(updatedStudent.id, updatedStudent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully')),
        );
        Navigator.pop(context, updatedStudent); // Navigate back with the updated student
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating student: $e')),
        );
      }
    }
  }
}








