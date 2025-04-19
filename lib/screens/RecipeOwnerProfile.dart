import 'package:flutter/material.dart';
import '../widgets/CustomNavigationBar.dart';

class RecipeOwnerProfile extends StatelessWidget {
  const RecipeOwnerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 4,
        onTap: (index) {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(radius: 50),
            const SizedBox(height: 8),
            Text("Name Here", style: theme.textTheme.headlineSmall),
            const Text("username • email"),
            const SizedBox(height: 12),
            const Text("Bio:\n• Specialties\n• Experience"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _StatBox(title: "Years", value: "8"),
                _StatBox(title: "Recipes", value: "27"),
                _StatBox(title: "Ingredients", value: "83"),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("User’s Recipes", style: theme.textTheme.titleMedium),
            ),
            const SizedBox(height: 10),
            const _RecipeRow(),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;

  const _StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(title),
      ],
    );
  }
}

class _RecipeRow extends StatelessWidget {
  const _RecipeRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        3,
        (index) => Card(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(child: Text("Recipe ${index + 1}")),
          ),
        ),
      ),
    );
  }
}
