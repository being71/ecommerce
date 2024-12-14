import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email.';
        _successMessage = '';
      });
      return;
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      setState(() {
        _successMessage = 'Password reset email sent. Please check your inbox.';
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _successMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Forget Password'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter your email to receive a password reset link:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Get Password button
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Get Reset Link'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 223, 17, 2),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Error or success message
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (_successMessage.isNotEmpty)
              Text(
                _successMessage,
                style: const TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
