import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDetails extends StatefulWidget {
  final String recipeId;
  const RecipeDetails({super.key, required this.recipeId});
  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  Map<String, dynamic>? recipeData;
  List<Map<String, dynamic>> comments = [];
  List<double> allRatings = [];
  double _userRating = 0.0;
  bool isFavorite = false;
  bool isZoomed = false;
  final TextEditingController _commentController = TextEditingController();
  String? userId;

  // Ingredient handling
  List<Map<String, dynamic>> expandedIngredients = [];
  bool loadingIngredients = true;
  final ScrollController _ingredientsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    fetchRecipe();
    fetchComments();
    checkFavoriteStatus();
  }

  Future<void> fetchRecipe() async {
    final doc = await FirebaseFirestore.instance.collection('recipes').doc(widget.recipeId).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        recipeData = data;
      });
      await fetchUserRating();
      await fetchAllRatings();
      if (userId != null && data['category'] != null) {
        await FirebaseFirestore.instance
            .collection('users').doc(userId)
            .collection('clickedCategories').doc(data['category'])
            .set({'clicks': FieldValue.increment(1)}, SetOptions(merge: true));
      }
      await fetchAndExpandIngredients();
    }
  }

  Future<void> fetchAndExpandIngredients() async {
    setState(() { loadingIngredients = true; });
    final ingredientsArr = recipeData?['ingredients'] as List? ?? [];
    List<Map<String, dynamic>> result = [];
    for (final entry in ingredientsArr) {
      if (entry is Map<String, dynamic> && entry['ingredientId'] != null) {
        final ingDoc = await FirebaseFirestore.instance
            .collection('ingredients')
            .doc(entry['ingredientId'])
            .get();
        if (ingDoc.exists) {
          final meta = ingDoc.data()!;
          result.add({ ...entry, ...meta });
        } else {
          result.add({ ...entry, 'name': '(Unknown)', 'price': null, 'stock': null });
        }
      }
    }
    setState(() {
      expandedIngredients = result;
      loadingIngredients = false;
    });
  }

  Future<void> fetchUserRating() async {
    if (userId == null) return;
    final ratingDoc = await FirebaseFirestore.instance
        .collection('recipes').doc(widget.recipeId)
        .collection('ratings').doc(userId).get();
    if (ratingDoc.exists && ratingDoc.data()?['value'] != null) {
      setState(() {
        _userRating = (ratingDoc.data()!['value'] as num).toDouble();
      });
    } else {
      setState(() {
        _userRating = 0.0;
      });
    }
  }

  Future<void> fetchAllRatings() async {
    final snap = await FirebaseFirestore.instance
        .collection('recipes').doc(widget.recipeId)
        .collection('ratings').get();
    final List<double> ratings = snap.docs
        .map((doc) => (doc.data()['value'] as num?)?.toDouble())
        .whereType<double>()
        .toList();
    setState(() {
      allRatings = ratings;
    });
  }

  Future<void> updateUserRating(double newRating) async {
    if (userId == null) return;
    await FirebaseFirestore.instance
        .collection('recipes').doc(widget.recipeId)
        .collection('ratings').doc(userId)
        .set({'value': newRating});
    setState(() { _userRating = newRating; });
    await fetchAllRatings();
  }

  double get averageRating {
    if (allRatings.isEmpty) return 0.0;
    return allRatings.reduce((a, b) => a + b) / allRatings.length;
  }

  Future<void> fetchComments() async {
    final snap = await FirebaseFirestore.instance
        .collection('recipes').doc(widget.recipeId)
        .collection('comments').orderBy('createdAt', descending: true).get();
    final List<Map<String, dynamic>> fetchedComments = [];
    final Map<String, String> userCache = {};
    for (var doc in snap.docs) {
      final data = doc.data();
      final uid = data['userId'] ?? 'unknown';
      if (!userCache.containsKey(uid)) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        String displayName = 'Unknown';
        if (userDoc.exists && userDoc.data() != null) {
          final user = userDoc.data()!;
          displayName = '${user['name'] ?? ''} ${user['surname'] ?? ''}'.trim();
        }
        userCache[uid] = displayName;
      }
      data['userName'] = userCache[uid];
      fetchedComments.add(data);
    }
    setState(() { comments = fetchedComments; });
  }

  Future<void> checkFavoriteStatus() async {
    if (userId == null) return;
    final favDoc = await FirebaseFirestore.instance
        .collection('users').doc(userId)
        .collection('favorites').doc('list')
        .get();
    final ids = favDoc.data()?['recipeIds'] ?? [];
    setState(() {
      isFavorite = ids.contains(widget.recipeId);
    });
  }

  Future<void> toggleFavorite() async {
    if (userId == null) return;
    final favRef = FirebaseFirestore.instance
        .collection('users').doc(userId)
        .collection('favorites').doc('list');
    final snap = await favRef.get();
    List<dynamic> currentFavorites = snap.exists ? (snap.data()?['recipeIds'] ?? []) : [];
    bool isInFavorites = currentFavorites.contains(widget.recipeId);
    if (isInFavorites) {
      await favRef.update({'recipeIds': FieldValue.arrayRemove([widget.recipeId])});
    } else {
      await favRef.set({'recipeIds': FieldValue.arrayUnion([widget.recipeId])}, SetOptions(merge: true));
    }
    setState(() { isFavorite = !isInFavorites; });
  }

  Widget buildStarRating(double rating, void Function(double) onRate) {
    return Row(
      children: List.generate(5, (index) {
        double starValue = index + 1;
        return GestureDetector(
          onTap: () => onRate(starValue),
          onDoubleTap: () => onRate(starValue - 0.5),
          child: Icon(
            rating >= starValue
                ? Icons.star
                : (rating >= starValue - 0.5 ? Icons.star_half : Icons.star_border),
            color: Colors.orange,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (recipeData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final recipeName = recipeData!['recipeName'] ?? '';
    final recipeAuthor = recipeData!['author'] ?? '';
    final instructions = recipeData!['instructions'] ?? '';
    final cookTime = recipeData!['cookTime'] ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipeData!['imageUrl']?.toString().trim().isNotEmpty == true)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipeData!['imageUrl'] ?? '',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/placeholder.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(recipeName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildStarRating(_userRating, updateUserRating),
                    const SizedBox(width: 10),
                    Text("($cookTime min)", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Average Rating: ${averageRating.toStringAsFixed(1)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(isZoomed ? Icons.zoom_out : Icons.zoom_in),
                      onPressed: () {
                        setState(() { isZoomed = !isZoomed; });
                      },
                    )
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: isZoomed ? 250 : 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Text(instructions, style: const TextStyle(color: Colors.black87)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final authorId = recipeData!['authorId'];
                        if (authorId != null) {
                          Navigator.pushNamed(
                            context,
                            '/profile',
                            arguments: {'userId': authorId},
                          );
                        }
                      },
                      child: const CircleAvatar(radius: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Text(recipeAuthor, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            onPressed: toggleFavorite,
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // --- INGREDIENTS SECTION ---
                const Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  height: 320,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: loadingIngredients
                    ? Center(child: CircularProgressIndicator())
                    : Scrollbar(
                        controller: _ingredientsScrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _ingredientsScrollController,
                          itemCount: expandedIngredients.length,
                          itemBuilder: (context, index) {
                            final ing = expandedIngredients[index];
                            final name = ing['name'] ?? '';
                            final amount = ing['amount'] ?? '';
                            final unit = ing['unit'] ?? '';
                            final price = ing['price'];
                            final stock = ing['stock'];
                            return ListTile(
                              title: Text("$amount $unit $name"),
                              subtitle: Text("Price: ${price ?? '-'} | Stock: ${stock ?? '-'}"),
                              trailing: IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: userId == null ? null : () async {
                                  await FirebaseFirestore.instance
                                    .collection('users').doc(userId)
                                    .collection('cart')
                                    .add({
                                      'ingredientId': ing['ingredientId'],
                                      'name': name,
                                      'amount': amount,
                                      'unit': unit,
                                      'price': price,
                                    });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Added $amount $unit $name to cart!")),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                    ),
                ),
                // --- END INGREDIENTS SECTION ---
                const SizedBox(height: 20),
                const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                  child: Scrollbar(
                    child: comments.isEmpty
                        ? const Center(child: Text("No comments yet."))
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final c = comments[index];
                              return Text("👤 ${c['userName'] ?? 'User'}: ${c['text']}");
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final text = _commentController.text.trim();
                        if (text.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection('recipes').doc(widget.recipeId)
                              .collection('comments')
                              .add({
                            'text': text,
                            'userId': userId ?? 'anon',
                            'createdAt': Timestamp.now(),
                          });
                          _commentController.clear();
                          await fetchComments();
                        }
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
