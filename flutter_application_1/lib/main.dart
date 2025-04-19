import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Make sure this path matches your folder

void main() {
  runApp(const CheffBuddyApp());
}

class CheffBuddyApp extends StatelessWidget {
  const CheffBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cheff Buddy',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}