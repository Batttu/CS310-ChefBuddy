import 'package:flutter/material.dart';

class CreateRecipe extends StatefulWidget {
  @override
  _CreateRecipeState createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _ingredientAmountController = TextEditingController();
  final _cookTimeController = TextEditingController();

  List<Map<String, String>> _ingredients = [];

  void _addIngredient() {
    final name = _ingredientNameController.text.trim();
    final amount = _ingredientAmountController.text.trim();
    if (name.isNotEmpty && amount.isNotEmpty) {
      setState(() {
        _ingredients.add({'name': name, 'amount': amount});
        _ingredientNameController.clear();
        _ingredientAmountController.clear();
      });
    }
  }

  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      print('Title: ${_titleController.text}');
      print('Instructions: ${_instructionsController.text}');
      print('Cook time: ${_cookTimeController.text}');
      print('Ingredients: $_ingredients');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe Submitted!')),
      );
    }
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

              // Asset image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/placeholder.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 16),

              // Recipe name
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Recipe Title'),
                validator: (val) => val == null || val.isEmpty ? 'Enter title' : null,
              ),

              SizedBox(height: 12),

              // Instructions
              TextFormField(
                controller: _instructionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Instructions',
                  alignLabelWithHint: true,
                ),
              ),

              SizedBox(height: 12),

              // Cook Time
              TextFormField(
                controller: _cookTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cook Time (minutes)',
                  suffixIcon: Icon(Icons.timer),
                ),
              ),

              SizedBox(height: 16),

              Text('Ingredients', style: TextStyle(fontWeight: FontWeight.bold)),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ingredientNameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _ingredientAmountController,
                      decoration: InputDecoration(hintText: 'Amount'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),

              ..._ingredients.map((ingredient) {
                return ListTile(
                  title: Text('${ingredient['name']} - ${ingredient['amount']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _ingredients.remove(ingredient);
                      });
                    },
                  ),
                );
              }).toList(),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _submitRecipe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
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
