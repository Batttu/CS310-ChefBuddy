import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipes');

  Future<void> addRecipe(Recipe recipe) async {
    await recipeCollection.add(recipe.toMap());
  }

  Stream<List<Recipe>> getRecipesStream() {
    return recipeCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Recipe.fromDoc(doc)).toList());
  }

  Future<void> updateRecipe(String id, Map<String, dynamic> data) async {
    await recipeCollection.doc(id).update(data);
  }

  Future<void> deleteRecipe(String id) async {
    await recipeCollection.doc(id).delete();
  }
}
