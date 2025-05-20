import 'package:flutter/material.dart';

class RecipeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _recipes = [];

  List<Map<String, dynamic>> get recipes => _recipes;

  void setRecipes(List<Map<String, dynamic>> newRecipes) {
    _recipes = newRecipes;
    notifyListeners();
  }

  void addRecipe(Map<String, dynamic> recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void removeRecipe(String id) {
    _recipes.removeWhere((recipe) => recipe['id'] == id);
    notifyListeners();
  }

  void clear() {
    _recipes = [];
    notifyListeners();
  }
}
