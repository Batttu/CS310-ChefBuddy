import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  String selectedDietary = '';
  String selectedCookTime = '';
  String ingredientFilter = '';

  final List<String> dietaryOptions = [
    'Vegan', 'Vegetarian', 'Gluten-Free',
    'High Protein', 'Low Carb', 'Dairy-Free'
  ];

  final List<String> cookTimeOptions = [
    '10mins', '30mins', '1hour'
  ];

  final List<String> ingredientAvailability = [
    'Only Show Recipes with My Ingredients',
    'Include Recipes Missing 1-2 Ingredients'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search & Filter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dietary Preferences',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: dietaryOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedDietary == option,
                  selectedColor: Colors.deepPurple[100],
                  onSelected: (_) {
                    setState(() => selectedDietary = option);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Cooking Time',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: cookTimeOptions.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: selectedCookTime == option,
                  selectedColor: Colors.deepPurple[100],
                  onSelected: (_) {
                    setState(() => selectedCookTime = option);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Ingredients Availability',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: ingredientAvailability.map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: ingredientFilter == option,
                  selectedColor: Colors.deepPurple[100],
                  onSelected: (_) {
                    setState(() => ingredientFilter = option);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'diet': selectedDietary,
                    'cookTime': selectedCookTime,
                    'availability': ingredientFilter
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
