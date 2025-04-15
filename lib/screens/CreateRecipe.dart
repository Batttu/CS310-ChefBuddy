import 'package:flutter/material.dart';
import '../widgets/CustomNavigationBar.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _ingredients = '';
  String _steps = '';
  String _cookingTime = '';
  final List<String> _submittedTitles = [];

  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submittedTitles.add(_title);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe submitted!')),
      );
      _formKey.currentState!.reset();
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Invalid Form'),
          content: Text('Please fill out all required fields.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
          ],
        ),
      );
    }
  }

  void _removeRecipe(int index) {
    setState(() {
      _submittedTitles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Placeholder image
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(child: Text('Upload Image Placeholder')),
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Recipe Title'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      onChanged: (value) => _title = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Ingredients'),
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      onChanged: (value) => _ingredients = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Steps'),
                      maxLines: 5,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      onChanged: (value) => _steps = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Cooking Time'),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      onChanged: (value) => _cookingTime = value,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: _submitRecipe, child: Text("Submit Recipe")),
                    SizedBox(height: 20),
                    Divider(),
                    Text("Submitted Recipes:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._submittedTitles.asMap().entries.map((entry) {
                      final i = entry.key;
                      final title = entry.value;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(title),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeRecipe(i),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle bottom nav
        },
      ),
    );
  }
}
