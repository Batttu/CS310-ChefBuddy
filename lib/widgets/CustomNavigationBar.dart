import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the device's width
    double deviceWidth = MediaQuery.of(context).size.width;

    return SafeArea( // Ensure the navigation bar is within safe UI boundaries
      child: Container(
        height: 70.0, // Standard height for BottomNavigationBar
        width: deviceWidth, // Ensure it fits the device's width
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Margin around the container
        decoration: BoxDecoration(
          //color: const Color.fromARGB(255, 174, 238, 220),
          //
          color: const Color.fromARGB(255, 168, 219, 255),
          //color: Color.fromARGB(255, 224, 197, 246),
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Ensure corners are clipped
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            onTap: onTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Recipes'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            selectedItemColor: Color.fromARGB(255, 33, 150, 243), // Hex: #2196F3
            //selectedItemColor: Color.fromARGB(255, 156, 39, 176),
            unselectedItemColor: Colors.white,
            showSelectedLabels: true, // Show labels for selected items
            showUnselectedLabels: true, // Show labels for unselected items
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text('Content goes here'),
            ),
          ),
          CustomNavigationBar(
            currentIndex: 0,
            onTap: (index) {
              // Handle navigation tap
            },
          ),
        ],
      ),
    ),
  ));
}
