import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

void main() {
  runApp(const CheffBuddyApp());
}

class CheffBuddyApp extends StatelessWidget {
  const CheffBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'WinkyRough', 
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              recipeName: args['recipeName']!,
              recipeAuthor: args['recipeAuthor']!,
              instructions: args['instructions']!,
            ),
          );
        }
        return null;
      },
    );
  }
}

