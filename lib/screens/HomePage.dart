import 'package:flutter/material.dart';
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

  final List<Map<String, String>> forYouRecipes = [
    {
      'title': 'Indonesian beef burger',
      'author': 'Adrianna Cull',
      'category': 'Lunch',
      'instructions': '1. Season beef\n2. Cook patties\n3. Assemble burger with bun and vegetables.',
      'image': 'https://images.unsplash.com/photo-1613160775054-d4a634592b7f?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'title': 'Home made cute pancake',
      'author': 'James Wolden',
      'category': 'Breakfast',
      'instructions': '1. Mix ingredients\n2. Heat pan\n3. Pour batter and flip.',
      'image': 'https://images.unsplash.com/photo-1659549591799-0ba408a9b29a?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
    {
      'title': 'How to make fried crab',
      'author': 'Paprika Anr',
      'category': 'Dinner',
      'instructions': '1. Clean crabs\n2. Season and flour\n3. Deep fry till golden.',
      'image': 'https://plus.unsplash.com/premium_photo-1719611418753-526e29c9baff?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    },
  ];

  final List<Map<String, String>> recipes = [
    {
      'title': 'Spaghetti Bolognese',
      'author': 'Anna Smith',
      'category': 'Lunch',
      'instructions': '1. Cook pasta\n2. Prepare sauce\n3. Mix together.',
      'image': 'assets/images/s.jpg'
    },
    {
      'title': 'Classic Caesar Salad',
      'author': 'Julia Green',
      'category': 'Dinner',
      'instructions': '1. Chop lettuce\n2. Add dressing\n3. Serve with croutons.',
      'image': 'assets/images/c.jpg'
    },
    {
      'title': 'Omelette with herbs',
      'author': 'Tom Hardy',
      'category': 'Breakfast',
      'instructions': '1. Beat eggs\n2. Add herbs\n3. Cook on skillet.',
      'image': 'assets/images/o.webp'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = recipes.where((r) {
      final matchCategory = selectedCategory.isEmpty || r['category'] == selectedCategory;
      final matchSearch = searchQuery.isEmpty || r['title']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    final filteredForYou = forYouRecipes.where((r) {
      final matchCategory = selectedCategory.isEmpty || r['category'] == selectedCategory;
      final matchSearch = searchQuery.isEmpty || r['title']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

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
              recipeSection("For you", filteredForYou, true),
              const SizedBox(height: 30),
              recipeSection("Recipes", filteredRecipes, true),
              const SizedBox(height: 80),
            ],
          ),
        ),
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

  Widget recipeSection(String title, List<Map<String, String>> recipeList, bool useImage) {
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
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: {
                    'recipeName': recipeList[index]['title']!,
                    'recipeAuthor': recipeList[index]['author']!,
                    'instructions': recipeList[index]['instructions']!,
                  },
                );
              },
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[300],
                  image: recipeList[index].containsKey('image')
                      ? DecorationImage(
                          image: recipeList[index]['image']!.startsWith('assets/')
                              ? AssetImage(recipeList[index]['image']!) as ImageProvider
                              : NetworkImage(recipeList[index]['image']!),
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
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent
                            ],
                          ),
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        recipeList[index]['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: useImage ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recipeList[index]['author']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: useImage ? Colors.white70 : Colors.black54,
                        ),
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

