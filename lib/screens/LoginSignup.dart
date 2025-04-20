import 'package:flutter/material.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final TextEditingController _loginUsername = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();
  final TextEditingController _signupUsername = TextEditingController();
  final TextEditingController _signupPassword = TextEditingController();
  final TextEditingController _signupConfirm = TextEditingController();

  void _showInvalidFormAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Form"),
        content: const Text("Please correct the errors in the form."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "👨‍🍳 ChefBuddy",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text("Login", style: theme.textTheme.titleLarge),
              const SizedBox(height: 10),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _loginUsername,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _loginPassword,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_loginFormKey.currentState!.validate()) {
                          Navigator.pushReplacementNamed(context, '/main');
                        } else {
                          _showInvalidFormAlert();
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
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
                        if (value == null || value.isEmpty) {
                          return "Username required";
                        }
                        if (value.length > 20) {
                          return "Max 20 characters allowed";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _signupPassword,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _signupConfirm,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      validator: (value) {
                        if (value != _signupPassword.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (_signupFormKey.currentState!.validate()) {
                          Navigator.pushReplacementNamed(context, '/main');
                        } else {
                          _showInvalidFormAlert();
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
      ),
    );
  }
}
