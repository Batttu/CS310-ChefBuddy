import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/SearchBar.dart' as CustomSearchBar;
import 'RecipeDetails.dart';
import 'SearchFilter.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Vegan'];
  String selectedCategory = 'Lunch';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Category', style: GoogleFonts.rubik(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black),
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchFilter()),
              );
              // You can apply your filters here if desired
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(category, style: GoogleFonts.rubik()),
                      selected: category == selectedCategory,
                      selectedColor: Color.fromARGB(255, 224, 197, 246),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          CustomSearchBar.SearchBar(
            onSearch: (query) {
              setState(() {
                searchQuery = query;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recipes')
                  .where('category', isEqualTo: selectedCategory)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                final filteredDocs = searchQuery.isEmpty
                    ? docs
                    : docs.where((doc) {
                        final name = (doc['recipeName'] ?? '').toString().toLowerCase();
                        return name.contains(searchQuery.toLowerCase());
                      }).toList();
                if (filteredDocs.isEmpty) {
                  return Center(child: Text('No recipes found.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredDocs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetails(recipeId: recipe.id),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                        child: Column(
                          children: [
                            Container(
                              height: 180.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                                child: Image.network(
                                  recipe['imageUrl'] ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (ctx, e, stack) => Icon(Icons.image, size: 40),
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  recipe['recipeName'] ?? '-',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [Icon(Icons.star, size: 16, color: Colors.yellow),
                                      SizedBox(width: 4),
                                      Text('4/5'), // Replace with live data if you wish
                                    ],
                                  ),
                                  Row(
                                    children: [Icon(Icons.timer, size: 16),
                                      SizedBox(width: 4),
                                      Text('${recipe['cookTime'] ?? '--'} min'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // **FAB removed: users add via elsewhere in your app**
    );
  }
}
