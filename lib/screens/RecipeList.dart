import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import '../widgets/SearchBar.dart' as CustomSearchBar; // Alias the custom SearchBar
import 'RecipeDetails.dart'; // Import RecipeDetails screen
import 'SearchFilter.dart';


void main() {
  runApp(MaterialApp(
    home: RecipeList(),
  ));
}

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final List<String> categories = ['Breakfast', 'Lunch', 'Dinner', 'Vegan'];
  String selectedCategory = 'Lunch'; // Default selected category
  String searchQuery = ''; // Store the search query
  final Set<String> favoriteRecipes = {}; // Track favorite recipes by name

  final Map<String, List<Map<String, String>>> categoryRecipes = {
    'Breakfast': [
      {'name': 'Pancakes', 'image': 'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg'},
      {'name': 'Croissant', 'image': 'https://images.pexels.com/photos/3892469/pexels-photo-3892469.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Avocado Toast', 'image': 'https://images.pexels.com/photos/704569/pexels-photo-704569.jpeg'},
      {'name': 'Smoothie Bowl', 'image': 'https://images.pexels.com/photos/2173774/pexels-photo-2173774.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
    ],
    'Lunch': [
      {'name': 'Chickpea Soup', 'image': 'https://images.pexels.com/photos/13788765/pexels-photo-13788765.jpeg'},
      {'name': 'Red Sauce Pasta', 'image': 'https://images.pexels.com/photos/17499766/pexels-photo-17499766.jpeg'},
      {'name': 'Tacos', 'image': 'https://images.pexels.com/photos/5837103/pexels-photo-5837103.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Grilled Chicken', 'image': 'https://images.pexels.com/photos/15532964/pexels-photo-15532964/free-photo-of-photo-of-a-chicken-breast-meal.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Avocado Salad', 'image': 'https://images.pexels.com/photos/1213710/pexels-photo-1213710.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
    ],
    'Dinner': [
      {'name': 'Chickpea Soup', 'image': 'https://images.pexels.com/photos/13788765/pexels-photo-13788765.jpeg'},
      {'name': 'Red Sauce Pasta', 'image': 'https://images.pexels.com/photos/17499766/pexels-photo-17499766.jpeg'},
      {'name': 'Avocado Salad', 'image': 'https://images.pexels.com/photos/1213710/pexels-photo-1213710.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Grilled Chicken', 'image': 'https://images.pexels.com/photos/15532964/pexels-photo-15532964/free-photo-of-photo-of-a-chicken-breast-meal.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
    ],
    'Vegan': [
      {'name': 'Chickpea Soup', 'image': 'https://images.pexels.com/photos/13788765/pexels-photo-13788765.jpeg'},
      {'name': 'Red Sauce Pasta', 'image': 'https://images.pexels.com/photos/17499766/pexels-photo-17499766.jpeg'},
      {'name': 'Avocado Salad', 'image': 'https://images.pexels.com/photos/1213710/pexels-photo-1213710.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'},
      {'name': 'Avocado Toast', 'image': 'https://images.pexels.com/photos/704569/pexels-photo-704569.jpeg'},
    ],
  };

  List<Map<String, String>> get filteredRecipes {
    final recipes = categoryRecipes[selectedCategory] ?? [];
    if (searchQuery.isEmpty) return recipes;
    return recipes.where((recipe) => recipe['name']!.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: Text(
          'Category',
          style: GoogleFonts.rubik(fontWeight: FontWeight.bold, color: Colors.black), 
        ),
        backgroundColor: Colors.white, //white background for the AppBar
        elevation: 0, 
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black), 
            onPressed: () async {
              final filters = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchFilter()),
              );

              if (filters != null) {
                print('Selected filters: $filters');
                // You can filter your recipe data based on filters['diet'], filters['cookTime'], etc.
              }
            },

          ),
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
                      label: Text(
                        category,
                        style: GoogleFonts.rubik(),
                      ),
                      selected: category == selectedCategory,
                      selectedColor: Color.fromARGB(255, 224, 197, 246), // prple color for selected categories
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
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75, //  aspect ratio for larger images
              ),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                final isFavorite = favoriteRecipes.contains(recipe['name']); // Check if the recipe is a favorite

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetails(recipe: recipe), // Navigate to RecipeDetails
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 180.0, // stat height for all images
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                                child: Image.network(
                                  recipe['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Spacer(), 
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Add vertical padding
                              child: Center(
                                child: Text(
                                  recipe['name']!,
                                  textAlign: TextAlign.center, 
                                  style: TextStyle(
                                    fontSize: 14.0, // adjs font size if needed
                                    overflow: TextOverflow.visible, 
                                  ),
                                ),
                              ),
                            ),
                            Spacer(), 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0), // Move star/timer further down
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 16, color: Colors.yellow), // Yellow star
                                      SizedBox(width: 4),
                                      Text('4/5'), //  rating
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.timer, size: 16),
                                      SizedBox(width: 4),
                                      Text('30 min'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isFavorite) {
                                  favoriteRecipes.remove(recipe['name']); // Remove from favorites
                                } else {
                                  favoriteRecipes.add(recipe['name']!); // Add to favorites
                                }
                              });
                            },
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey, // red when pressed,grey otherwise
                              size: 24.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
