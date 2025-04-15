import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final _formKey = GlobalKey<FormState>();
  String _diet = 'Vegan';
  String _cookingTime = '';
  bool includeMyIngredients = true;

  void _applyFilters() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context); // Go back to RecipeList with applied filters
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Invalid Filter"),
          content: Text("Please fill required fields."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search & Filter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _diet,
                items: ['Vegan', 'Keto', 'Vegetarian', 'Gluten-Free']
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (val) => setState(() => _diet = val!),
                decoration: InputDecoration(labelText: "Dietary Preference"),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Cooking Time (in mins)"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
                onChanged: (val) => _cookingTime = val,
              ),
              SizedBox(height: 16),
              CheckboxListTile(
                title: Text("Only show recipes with my ingredients"),
                value: includeMyIngredients,
                onChanged: (val) => setState(() => includeMyIngredients = val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _applyFilters, child: Text("Apply")),
            ],
          ),
        ),
      ),
    );
  }
}
