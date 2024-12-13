import 'package:flutter/material.dart';
import 'firestore.dart'; // Import file firestore.dart
import 'login.dart'; // Ganti dengan nama halaman login Anda
import 'package:firebase_auth/firebase_auth.dart';

class Daftar extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran'),
        backgroundColor: Color.fromARGB(255, 223, 17, 2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Form key untuk validasi
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Nama',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Email',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  final regex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!regex.hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password harus lebih dari 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Ambil data dari controller
                    String name = nameController.text;
                    String email = emailController.text;
                    String password = passwordController.text;

                    try {
                      // Pendaftaran di Firebase Authentication langsung tanpa variabel userCredential
                      await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // Daftarkan pengguna ke Firestore
                      await _firestoreService.registerUser(name, email);

                      // Tampilkan snackbar setelah berhasil
                      _showSuccessDialog(context);
                    } on FirebaseAuthException catch (e) {
                      // Menangani error jika ada masalah saat registrasi
                      print('Error: ${e.message}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'Error')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 223, 17, 2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Daftar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Membuat dialog tidak bisa ditutup dengan klik di luar
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pendaftaran Berhasil!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Akun Anda telah berhasil terdaftar. Klik OK untuk melanjutkan ke halaman login.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigasi ke halaman login setelah klik OK
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false, // Ganti dengan login.dart
                );
              },
              child: const Text('OK', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
}
