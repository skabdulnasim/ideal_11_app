import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool otpSent = false;
  bool loading = false;

  void sendOtp() async {
    setState(() => loading = true);
    final response = await ApiService.sendOtp(phoneController.text);
    setState(() {
      otpSent = response;
      loading = false;
    });
  }

  void verifyOtp() async {
    setState(() => loading = true);
    final success = await ApiService.verifyOtp(
      phoneController.text,
      otpController.text,
    );
    setState(() => loading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/profile-info');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login / Register")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            if (otpSent)
              TextField(
                controller: otpController,
                decoration: InputDecoration(labelText: "Enter OTP"),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: otpSent ? verifyOtp : sendOtp,
                  child: Text(otpSent ? "Verify OTP" : "Send OTP"),
                ),
          ],
        ),
      ),
    );
  }
}
