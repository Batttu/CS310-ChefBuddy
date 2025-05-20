import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = '';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.defaultBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Find best recipes\nfor cooking',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search recipes',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              categorySection(),
              const SizedBox(height: 20),
              if (userId != null) forYouSection(userId),
              const SizedBox(height: 30),
              recipeStreamSection("Recipes", useImage: true),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget forYouSection(String userId) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getPersonalizedForYouRecipes(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("For You", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Text("No personalized suggestions yet."),
            ],
          );
        }
        return recipeSection("For You", snapshot.data!, true);
      },
    );
  }

  Future<List<DocumentSnapshot>> getPersonalizedForYouRecipes(String userId) async {
    final categorySnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('clickedCategories')
        .get();

    if (categorySnap.docs.isEmpty) return [];

    final categoryClicks = categorySnap.docs.map((doc) {
      return {
        'category': doc.id,
        'clicks': (doc.data()['clicks'] ?? 0) as int,
      };
    }).toList();

    categoryClicks.sort((a, b) {
      final int bClicks = b['clicks'] as int? ?? 0;
      final int aClicks = a['clicks'] as int? ?? 0;
      final cmp = bClicks.compareTo(aClicks);
      final String aCategory = a['category'] as String? ?? '';
      final String bCategory = b['category'] as String? ?? '';
      return cmp != 0 ? cmp : aCategory.compareTo(bCategory);
    });

    final top3 = categoryClicks.take(3).toList();
    final limits = [3, 2, 1];
    final remaining = categoryClicks.skip(3).toList();

    List<DocumentSnapshot> result = [];

    for (int i = 0; i < top3.length; i++) {
      final cat = top3[i]['category'];
      final snap = await FirebaseFirestore.instance
          .collection('recipes')
          .where('category', isEqualTo: cat)
          .get();

      final sorted = await sortRecipesByRatingAndName(snap.docs);
      result.addAll(sorted.take(limits[i]));
    }

    for (var entry in remaining) {
      final snap = await FirebaseFirestore.instance
          .collection('recipes')
          .where('category', isEqualTo: entry['category'])
          .get();

      final sorted = await sortRecipesByRatingAndName(snap.docs);
      if (sorted.isNotEmpty) result.add(sorted.first);
    }

    return result;
  }

  Future<List<DocumentSnapshot>> sortRecipesByRatingAndName(List<DocumentSnapshot> docs) async {
    List<Map<String, dynamic>> withRatings = [];

    for (var doc in docs) {
      final ratingsSnap = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(doc.id)
          .collection('ratings')
          .get();

      final ratings = ratingsSnap.docs.map((d) => (d.data()['value'] as num?)?.toDouble()).whereType<double>().toList();
      final avgRating = ratings.isEmpty ? 0.0 : ratings.reduce((a, b) => a + b) / ratings.length;

      withRatings.add({
        'doc': doc,
        'avg': avgRating,
        'name': (doc.data() as Map<String, dynamic>)['recipeName'] ?? '',
      });
    }

    withRatings.sort((a, b) {
      final cmp = (b['avg'] as double).compareTo(a['avg'] as double);
      return cmp != 0 ? cmp : (a['name'] as String).compareTo(b['name'] as String);
    });

    return withRatings.map((e) => e['doc'] as DocumentSnapshot).toList();
  }

  Widget categorySection() {
    final categories = ['Lunch', 'Dinner', 'Breakfast', 'Desserts'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('See all →', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.map((label) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = selectedCategory == label ? '' : label;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedCategory == label ? Colors.black : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selectedCategory == label ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget recipeStreamSection(String title, {required bool useImage}) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }

        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final matchCategory = selectedCategory.isEmpty || data['category'] == selectedCategory;
          final matchSearch = searchQuery.isEmpty || data['recipeName'].toString().toLowerCase().contains(searchQuery.toLowerCase());
          return matchCategory && matchSearch;
        }).toList();

        return recipeSection(title, docs, useImage);
      },
    );
  }

  Widget recipeSection(String title, List<DocumentSnapshot> docs, bool useImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('See all →', style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: {'recipeId': docId},
                  );
                },
                child: Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                    image: data['imageUrl'] != null
                        ? DecorationImage(
                            image: data['imageUrl'].toString().startsWith('assets/')
                                ? AssetImage(data['imageUrl']) as ImageProvider
                                : NetworkImage(data['imageUrl']),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: useImage
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            ),
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          data['recipeName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: useImage ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['author'],
                          style: TextStyle(
                            fontSize: 12,
                            color: useImage ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
