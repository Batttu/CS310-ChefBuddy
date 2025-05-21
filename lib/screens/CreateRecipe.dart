import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _amountController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _imageUrlController = TextEditingController();

  List<Map<String, dynamic>> _ingredients = [];
  String? _selectedCategory;
  String? _selectedUnit;
  final List<String> _categories = ['Breakfast', 'Lunch', 'Dinner', 'Vegan'];
  final List<String> _units = ['g', 'ml', 'pcs'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories[0];
    _selectedUnit = _units[0];
  }

  void _addIngredient() {
    final name = _ingredientController.text.trim();
    final amountStr = _amountController.text.trim();
    final unit = _selectedUnit;
    if (name.isNotEmpty && amountStr.isNotEmpty && unit != null) {
      final amount = num.tryParse(amountStr);
      if (amount == null || amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter a valid amount')),
        );
        return;
      }
      setState(() {
        _ingredients.add({
          'name': name,
          'amount': amount,
          'unit': unit,
        });
        _ingredientController.clear();
        _amountController.clear();
        _selectedUnit = _units[0];
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<String> _findOrCreateIngredientDoc(String name) async {
    final existing = await FirebaseFirestore.instance
        .collection('ingredients')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id;
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('ingredients')
          .add({'name': name});
      return doc.id;
    }
  }

  Future<void> _submitRecipe() async {
    if (_formKey.currentState!.validate() && _ingredients.isNotEmpty) {
      // Build final ingredients array with IDs
      List<Map<String, dynamic>> finalIngredients = [];
      for (final ing in _ingredients) {
        final ingredientId = await _findOrCreateIngredientDoc(ing['name']);
        finalIngredients.add({
          'ingredientId': ingredientId,
          'amount': ing['amount'],
          'unit': ing['unit'],
        });
      }
      await FirebaseFirestore.instance.collection('recipes').add({
        'recipeName': _titleController.text.trim(),
        'author': 'Your Name',
        'category': _selectedCategory,
        'instructions': _instructionsController.text.trim(),
        'cookTime': int.tryParse(_cookTimeController.text.trim()) ?? 0,
        'createdBy': 'currentUserUid', // Replace with actual user id
        'createdAt': Timestamp.now(),
        'imageUrl': _imageUrlController.text.trim(),
        'ingredients': finalIngredients, // Referenced by ID now!
        'ratings': [],
        'comments': [],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe Submitted!')),
      );
      setState(() {
        _titleController.clear();
        _instructionsController.clear();
        _ingredientController.clear();
        _amountController.clear();
        _cookTimeController.clear();
        _imageUrlController.clear();
        _ingredients.clear();
        _selectedCategory = _categories[0];
        _selectedUnit = _units[0];
      });
    } else if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add at least one ingredient!')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _ingredientController.dispose();
    _amountController.dispose();
    _cookTimeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Recipe')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Recipe Title'),
                validator: (val) => val == null || val.isEmpty ? 'Enter title' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL (optional)'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _instructionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Instructions',
                  alignLabelWithHint: true,
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter instructions' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _cookTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cook Time (minutes)',
                  suffixIcon: Icon(Icons.timer),
                ),
                validator: (val) {
                  final numVal = int.tryParse(val ?? '');
                  if (numVal == null || numVal <= 0) return 'Enter valid time';
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Ingredients', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ingredientController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Amount'),
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    items: _units
                        .map((unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedUnit = val),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              ..._ingredients.asMap().entries.map((entry) {
                final i = entry.key;
                final ing = entry.value;
                return ListTile(
                  title: Text(
                    "${ing['amount']} ${ing['unit']} ${ing['name']}",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeIngredient(i),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitRecipe,
                  child: Text('Submit Recipe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
