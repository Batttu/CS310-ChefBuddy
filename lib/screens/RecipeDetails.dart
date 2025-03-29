import 'package:flutter/material.dart';

class RecipeDetails extends StatelessWidget {
  final Map<String, String> recipe;

  const RecipeDetails({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name']!),
        backgroundColor: Colors.white, // Keep AppBar colorful
      ),
      body: Container(
        color: Colors.white, // White background for the screen
        child: Column(
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recipe['image']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe['name']!,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            // Add more details about the recipe here
          ],
        ),
      ),
    );
  }
}
