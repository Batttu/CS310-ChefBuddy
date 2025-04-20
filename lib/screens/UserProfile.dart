import 'package:flutter/material.dart';
import '../widgets/CustomNavigationBar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String name = 'Name Here';
  String username = 'username';
  String biography = 'Short biography of user';

  bool isSelectMode = false;
  Set<int> selectedRecipes = {};

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
          title: Text('Edit Profile',
              style: Theme.of(context).textTheme.titleLarge),
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
                  decoration:
                      const InputDecoration(labelText: 'Short Biography'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
      selectedRecipes.clear();
    });
  }

  void _removeSelectedRecipes(List<String> recipes) {
    setState(() {
      recipes.removeWhere(
          (recipe) => selectedRecipes.contains(recipes.indexOf(recipe)));
      selectedRecipes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: theme.textTheme.titleLarge),
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
            Row(
              children: [
                const CircleAvatar(radius: 40),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.headlineSmall),
                    Text(username,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(biography, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('96', 'Months with ChefBuddy'),
                const SizedBox(width: 16),
                _buildStat('27', 'Recipes Contributed'),
                const SizedBox(width: 16),
                _buildStat('83', 'Ingredients used'),
              ],
            ),
            const SizedBox(height: 30),
            DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: theme.colorScheme.primary,
                    tabs: const [
                      Tab(text: 'Favourite Recipes'),
                      Tab(text: 'My Recipes'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _buildRecipeGrid(favouriteRecipes),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final tabIndex = DefaultTabController.of(context)?.index ?? 0;
          if (isSelectMode) {
            if (tabIndex == 0) {
              _removeSelectedRecipes(favouriteRecipes);
            } else {
              _removeSelectedRecipes(myRecipes);
            }
          } else {
            _editProfile();
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: Icon(isSelectMode ? Icons.delete : Icons.edit),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/add');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/recipes');
              break;
            case 4:
              break;
          }
        },
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
      ],
    );
  }

  Widget _buildRecipeGrid(List<String> recipes) {
    final theme = Theme.of(context);
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
                    isSelected
                        ? selectedRecipes.remove(index)
                        : selectedRecipes.add(index);
                  });
                }
              : null,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.5)
                : Colors.white,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    recipes[index],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (isSelectMode)
                  Align(
                    alignment: Alignment.topRight,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          value == true
                              ? selectedRecipes.add(index)
                              : selectedRecipes.remove(index);
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
