import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = '';

  final List<Map<String, String>> recipes = [
    {
      'title': 'Indonesian beef burger',
      'author': 'Adrianna Cull',
      'category': 'Lunch',
      'instructions': '1. Season beef\n2. Cook patties\n3. Assemble burger with bun and vegetables.'
    },
    {
      'title': 'Home made cute pancake',
      'author': 'James Wolden',
      'category': 'Breakfast',
      'instructions': '1. Mix ingredients\n2. Heat pan\n3. Pour batter and flip.'
    },
    {
      'title': 'How to make fried crab',
      'author': 'Paprika Anr',
      'category': 'Dinner',
      'instructions': '1. Clean crabs\n2. Season and flour\n3. Deep fry till golden.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = selectedCategory.isEmpty
        ? recipes
        : recipes.where((r) => r['category'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Find best recipes\nfor cooking',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
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
              recipeSection("For you", filteredRecipes),
              const SizedBox(height: 30),
              recipeSection("Recipes", filteredRecipes),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {},
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
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

  Widget recipeSection(String title, List<Map<String, String>> recipeList) {
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
            itemCount: recipeList.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      recipeName: recipeList[index]['title']!,
                      recipeAuthor: recipeList[index]['author']!,
                      instructions: recipeList[index]['instructions']!,
                    ),
                  ),
                );
              },
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        recipeList[index]['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipeList[index]['author']!,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
