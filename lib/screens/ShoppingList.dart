import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Google Fonts package

void main() {
  runApp(MaterialApp(
    home: MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page')),
    Center(child: Text('Add Item Page')),
    ShoppingList(),
    Center(child: Text('Book Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final List<Map<String, dynamic>> items = [
    {'name': 'Ingredient 1', 'selected': false},
    {'name': 'Ingredient 2', 'selected': false},
    {'name': 'Ingredient 3', 'selected': false},
    {'name': 'Ingredient 4', 'selected': false},
    {'name': 'Ingredient 5', 'selected': false},
  ];

  final TextEditingController _controller = TextEditingController();

  bool get isAnySelected => items.any((item) => item['selected']);
  int get productCount => items.length; // counter for no of products

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Shopping Cart', 
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.bold,
            color: Color(0xFFB39DDB), 
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFB39DDB), 
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        hintText: 'Add item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addItem, //add item logic
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB39DDB), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0), 
                  child: GestureDetector(
                    onTap: _toggleSelection, // Toggle selection logic
                    child: Text(
                      _areAllSelected() ? 'Unselect All' : 'Select All', 
                      style: TextStyle(color: Color(0xFFB39DDB), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), 
                  child: Text(
                    '${productCount} items', 
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: ListTile(
                      leading: Checkbox(
                        value: items[index]['selected'],
                        onChanged: (bool? value) {
                          setState(() {
                            items[index]['selected'] = value!;
                          });
                        },
                      ),
                      title: Text(items[index]['name']),
                    ),
                  );
                },
              ),
            ),
            if (isAnySelected)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _deleteSelected, // Delete selected logic
                    child: Text('Delete', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0), 
                      side: BorderSide(color: Color(0xFFB39DDB)), 
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        items.add({'name': _controller.text, 'selected': false});
        _controller.clear();
      });
    }
  }

  void _deleteSelected() {
    setState(() {
      items.removeWhere((item) => item['selected']); // delete selected items
    });
  }

  void _toggleSelection() {
    setState(() {
      if (_areAllSelected()) {
        for (var item in items) {
          item['selected'] = false; // unselect all items
        }
      } else {
        for (var item in items) {
          item['selected'] = true; //select all items
        }
      }
    });
  }

  bool _areAllSelected() {
    return items.every((item) => item['selected']); //check if all items are selected
  }
}
