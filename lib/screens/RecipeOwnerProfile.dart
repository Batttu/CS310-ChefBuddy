import 'package:flutter/material.dart';
import '../widgets/CustomNavigationBar.dart';

class RecipeOwnerProfile extends StatelessWidget {
  const RecipeOwnerProfile({super.key});

  final List<String> usersRecipes = const [
    'Users Recipe 1',
    'Users Recipe 2',
    'Users Recipe 3',
    'Users Recipe 4',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Owner', style: theme.textTheme.titleLarge),
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
                    Text('Name Here', style: theme.textTheme.headlineSmall),
                    Text('username',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text('Professional chef focusing on Anatolian cuisine.',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(context, '120', 'Months Experience'),
                const SizedBox(width: 16),
                _buildStat(context, '54', 'Recipes Shared'),
                const SizedBox(width: 16),
                _buildStat(context, '210', 'Ingredients Used'),
              ],
            ),
            const SizedBox(height: 30),
            Text("User’s Recipes", style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(child: _buildRecipeGrid(context, usersRecipes)),
          ],
        ),
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

  Widget _buildStat(BuildContext context, String value, String label) {
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

  Widget _buildRecipeGrid(BuildContext context, List<String> recipes) {
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
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              recipes[index],
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }
}
