import 'dart:async';
import 'package:flutter/material.dart';
import '../services/RecipeService.dart';
import '../models/recipe.dart';
class RecipeProvider with ChangeNotifier {
  final RecipeService _service = RecipeService();
  List<Recipe> _recipes = [];
  bool _loading = false;
  String? _error;
  StreamSubscription? _subscription;

  List<Recipe> get recipes => _recipes;
  bool get loading => _loading;
  String? get error => _error;

  RecipeProvider() {
    subscribeToRecipes();
  }

  void subscribeToRecipes() {
    _loading = true;
    notifyListeners();
    _subscription = _service.getRecipesStream().listen((data) {
      _recipes = data;
      _loading = false;
      _error = null;
      notifyListeners();
    }, onError: (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
    });
  }

  Future<void> addRecipe(Recipe recipe) async {
    setLoading(true);
    try {
      await _service.addRecipe(recipe);
      setError(null);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> data) async {
    setLoading(true);
    try {
      await _service.updateRecipe(id, data);
      setError(null);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> deleteRecipe(String id) async {
    setLoading(true);
    try {
      await _service.deleteRecipe(id);
      setError(null);
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
