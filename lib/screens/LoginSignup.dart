import 'package:flutter/material.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _loginUsername = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  final TextEditingController _signupUsername = TextEditingController();
  final TextEditingController _signupPassword = TextEditingController();
  final TextEditingController _signupConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("👨‍🍳 ChefBuddy",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            Text("Login", style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            TextField(
              controller: _loginUsername,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _loginPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_loginUsername.text.isNotEmpty &&
                    _loginPassword.text.isNotEmpty) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot your password?"),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text("Sign Up", style: theme.textTheme.titleLarge),
            const SizedBox(height: 10),
            Form(
              key: _signupFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _signupUsername,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Username required";
                      if (value.length > 20) return "Max 20 characters allowed";
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _signupPassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Password required"
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _signupConfirm,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value != _signupPassword.text)
                        return "Passwords do not match";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_signupFormKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(context, '/main');
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
