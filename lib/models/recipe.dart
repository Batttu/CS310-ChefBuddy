import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String recipeName;
  final String author;
  final String category;
  final String instructions;
  final int cookTime;
  final String createdBy;
  final Timestamp createdAt;
  final String imageUrl;
  final List<String> ingredients; 
  final List<double> ratings;
  final List<Map<String, dynamic>> comments;

  Recipe({
    required this.id,
    required this.recipeName,
    required this.author,
    required this.category,
    required this.instructions,
    required this.cookTime,
    required this.createdBy,
    required this.createdAt,
    required this.imageUrl,
    required this.ingredients,
    required this.ratings,
    required this.comments,
  });

  factory Recipe.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      recipeName: data['recipeName'] ?? '',
      author: data['author'] ?? '',
      category: data['category'] ?? '',
      instructions: data['instructions'] ?? '',
      cookTime: data['cookTime'] ?? 0,
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      imageUrl: data['imageUrl'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []), // <-- Change here!
      ratings: List<double>.from((data['ratings'] ?? []).map((x) => x.toDouble())),
      comments: List<Map<String, dynamic>>.from(data['comments'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeName': recipeName,
      'author': author,
      'category': category,
      'instructions': instructions,
      'cookTime': cookTime,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'ratings': ratings,
      'comments': comments,
    };
  }
}
