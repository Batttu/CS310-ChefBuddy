import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = 'Name Here';
  String username = 'username';
  String biography = 'Short biography of user';

  bool isSelectMode = false; // Toggle for selection mode
  Set<int> selectedRecipes = {}; // Store selected recipe indices

  List<String> favouriteRecipes = [
    'Favourite Recipe 1',
    'Favourite Recipe 2',
    'Favourite Recipe 3',
    'Favourite Recipe 4',
  ];

  List<String> myRecipes = [
    'My Recipe 1',
    'My Recipe 2',
    'My Recipe 3',
    'My Recipe 4',
  ];

  void _editProfile() {
    final nameController = TextEditingController(text: name);
    final usernameController = TextEditingController(text: username);
    final bioController = TextEditingController(text: biography);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: bioController,
                  decoration: const InputDecoration(labelText: 'Short Biography'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text.trim();
                  username = usernameController.text.trim();
                  biography = bioController.text.trim();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelectMode() {
    setState(() {
      isSelectMode = !isSelectMode;
      selectedRecipes.clear(); // Clear selections when exiting select mode
    });
  }

  void _removeSelectedRecipes(List<String> recipes) {
    setState(() {
      recipes.removeWhere((recipe) => selectedRecipes.contains(recipes.indexOf(recipe)));
      selectedRecipes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(isSelectMode ? Icons.cancel : Icons.select_all),
            onPressed: _toggleSelectMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                const CircleAvatar(radius: 40),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text(username, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(biography, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Stats Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('96', 'Months with ChefBuddy'),
                const SizedBox(width: 16),
                _buildStatColumn('27', 'Recipes Contributed'),
                const SizedBox(width: 16),
                _buildStatColumn('83', 'Ingredients used'),
              ],
            ),
            const SizedBox(height: 30),

            // Tabs for Favourite Recipes and My Recipes
            DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TabBar(
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.deepPurple,
                    tabs: [
                      Tab(text: 'Favourite Recipes'),
                      Tab(text: 'My Recipes'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        // Favourite Recipes Grid
                        _buildRecipeGrid(favouriteRecipes),
                        // My Recipes Grid
                        _buildRecipeGrid(myRecipes),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isSelectMode
          ? FloatingActionButton(
              onPressed: () {
                // Remove selected recipes from the active tab
                final tabIndex = DefaultTabController.of(context)?.index ?? 0;
                if (tabIndex == 0) {
                  _removeSelectedRecipes(favouriteRecipes);
                } else {
                  _removeSelectedRecipes(myRecipes);
                }
              },
              child: const Icon(Icons.delete),
            )
          : FloatingActionButton(
              onPressed: _editProfile,
              child: const Icon(Icons.edit),
            ),
    );
  }

  // Helper method to build stats column
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Helper method to build recipe grid
  Widget _buildRecipeGrid(List<String> recipes) {
    return GridView.builder(
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final isSelected = selectedRecipes.contains(index);
        return GestureDetector(
          onTap: isSelectMode
              ? () {
                  setState(() {
                    if (isSelected) {
                      selectedRecipes.remove(index);
                    } else {
                      selectedRecipes.add(index);
                    }
                  });
                }
              : null,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: isSelected ? Colors.deepPurple.withOpacity(0.5) : Colors.white,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    recipes[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  ),
                ),
                if (isSelectMode)
                  Align(
                    alignment: Alignment.topRight,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedRecipes.add(index);
                          } else {
                            selectedRecipes.remove(index);
                          }
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
