import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ideal11/core/api_service.dart';

class ProfileInfoScreen extends StatefulWidget {
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  DateTime? selectedDOB;
  String gender = 'Male';
  bool loading = false;

  void _selectDOB(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDOB = picked);
    }
  }

  void _submitProfile() async {
    if (nameController.text.isEmpty ||
        selectedDOB == null ||
        cityController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => loading = true);

    bool success = await ApiService.updateProfile(
      name: nameController.text,
      gender: gender,
      dob: selectedDOB!.toIso8601String(),
      city: cityController.text,
    );

    setState(() => loading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update profile")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            DropdownButton<String>(
              value: gender,
              onChanged: (value) => setState(() => gender = value!),
              items:
                  ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDOB == null
                        ? 'Select Date of Birth'
                        : DateFormat('yyyy-MM-dd').format(selectedDOB!),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDOB(context),
                ),
              ],
            ),
            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: "City"),
            ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _submitProfile,
                  child: Text("Submit"),
                ),
          ],
        ),
      ),
    );
  }
}
