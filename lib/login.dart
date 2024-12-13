import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'daftar.dart';
import 'firestore.dart';
import 'home.dart'; // Import your catalog page

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    try {
      User? user = await FirestoreService().loginUser(email, password);

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _errorMessage = 'User not found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MANCHESTER UNITED SHOP'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/hif/f/ff/Manchester_United_FC_crest.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 5),
            const Text(
              'LOG IN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),

            // Username label and TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align label and TextField to the left
              children: [
                const Text(
                  'Username',
                  style: TextStyle(
                      fontSize: 14, // Smaller font size for the label
                      color: Colors.black, // Optional: change color to black
                      fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Add a border if needed
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Password label and TextField
            Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align label and TextField to the left
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 14, // Smaller font size for the label
                      color: Colors.black, // Optional: change color to black
                      fontWeight:
                          FontWeight.bold // Optional: change color to black
                      ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Add a border if needed
                  ),
                  obscureText: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Container to make the button the same width as the TextField
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white), // Change text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 223, 17, 2), // Set button background color to red
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Container to make the button the same width as the TextField
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Daftar()),
                  );
                },
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                      color: Colors.white), // Change text color to white
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 223, 17, 2), // Set button background color to red
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
