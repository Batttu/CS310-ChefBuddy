import 'package:flutter/material.dart';

class LoginSignup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to ChefBuddy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ChefBuddy',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                // Navigate to MainScreen after login
                Navigator.pushNamed(context, '/main');
              },
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
            const SizedBox(height: 10),

            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                // Navigate to MainScreen after sign up
                Navigator.pushNamed(context, '/main');
              },
              child: const Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
            const SizedBox(height: 10),

            // Login as Guest Button
            TextButton(
              onPressed: () {
                // Navigate to MainScreen as a guest
                Navigator.pushNamed(context, '/main');
              },
              child: const Text('Login as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}