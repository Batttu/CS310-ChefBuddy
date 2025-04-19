import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final String recipeName;
  final String recipeAuthor;
  final String instructions;

  const ProductDetailScreen({
    super.key,
    required this.recipeName,
    required this.recipeAuthor,
    required this.instructions,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  double _userRating = 4.0;
  List<double> allRatings = [4.0];
  final TextEditingController _commentController = TextEditingController();
  final List<String> comments = [
    '"This sandwich was amazing! The bread was fresh, and the fillings were perfectly balanced."'
  ];
  bool isFavorite = false;
  bool isZoomed = false;

  Map<String, bool> ingredientSelection = {
    "eggs": false,
    "Pickles": false,
    "Bread": false,
  };

  Widget buildStarRating(double rating, void Function(double) onRate) {
    return Row(
      children: List.generate(5, (index) {
        double starValue = index + 1;
        return GestureDetector(
          onTap: () => onRate(starValue),
          onDoubleTap: () => onRate(starValue - 0.5),
          child: Icon(
            rating >= starValue
                ? Icons.star
                : (rating >= starValue - 0.5
                    ? Icons.star_half
                    : Icons.star_border),
            color: Colors.orange,
          ),
        );
      }),
    );
  }

  double get averageRating {
    if (allRatings.isEmpty) return 0.0;
    double total = allRatings.reduce((a, b) => a + b);
    return (total / allRatings.length);
  }

  String get longInstructions =>
      '${widget.instructions}\n' * 10 + 'End of instructions.';

  void addToShoppingList() {
    List<String> selectedItems = ingredientSelection.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No ingredients selected.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added to shopping list: ${selectedItems.join(", ")}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.more_vert, color: Colors.black),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.recipeName,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    buildStarRating(_userRating, (newRating) {
                      setState(() {
                        _userRating = newRating;
                      });
                    }),
                    const SizedBox(width: 10),
                    const Text("(30 min)", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Instructions",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(isZoomed ? Icons.zoom_out : Icons.zoom_in),
                      onPressed: () {
                        setState(() {
                          isZoomed = !isZoomed;
                        });
                      },
                    )
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: isZoomed ? 250 : 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Text(
                        longInstructions,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    Text('(${allRatings.length} reviews)',
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const CircleAvatar(radius: 20),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.recipeAuthor,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                            )
                          ],
                        ),
                        const Text("Bali, Indonesia",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Comment...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          setState(() {
                            comments.add(_commentController.text.trim());
                            allRatings.add(_userRating);
                            _commentController.clear();
                          });
                        }
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Ingredients",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      tooltip: "Add to shopping list",
                      onPressed: addToShoppingList,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 160,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      children: ingredientSelection.keys.map((name) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: ingredientSelection[name],
                                onChanged: (bool? value) {
                                  setState(() {
                                    ingredientSelection[name] = value ?? false;
                                  });
                                },
                              ),
                              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: comments
                            .map((c) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text("Knocup: $c"),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          }
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
