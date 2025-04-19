import 'package:flutter/material.dart';
import '../widgets/CustomNavigationBar.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({Key? key}) : super(key: key);

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final _signupFormKey = GlobalKey<FormState>();

  final TextEditingController _loginUsernameController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signupUsernameController =
      TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("👨‍🍳 ChefBuddy",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Login", style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _loginUsernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _loginPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot your password?"),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            Text("OR", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Form(
              key: _signupFormKey,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sign Up", style: theme.textTheme.titleLarge),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _signupUsernameController,
                    decoration: const InputDecoration(labelText: "Username"),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Username required";
                      if (value.length > 20) return "Max 20 characters";
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _signupPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Password required"
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _signupConfirmPasswordController,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Password (Again)"),
                    validator: (value) {
                      if (value != _signupPasswordController.text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_signupFormKey.currentState!.validate()) {}
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
