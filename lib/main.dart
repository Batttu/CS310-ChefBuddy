import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import 'screens/RecipeList.dart';
import 'screens/CreateRecipe.dart';
import 'screens/ShoppingList.dart';
import 'screens/UserProfile.dart';
import 'widgets/CustomNavigationBar.dart'; // Import the custom navigation bar

void main() {
  runApp(ChefBuddyApp());
}

class ChefBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chef Buddy',
      theme: ThemeData(
        fontFamily: 'Rubik', // Use Rubik font
        scaffoldBackgroundColor: Colors.white, // Set default background to white
        primaryColor: Color.fromARGB(255, 186, 104, 200), // Pastel purple as primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 186, 104, 200),
          secondary: const Color.fromARGB(255, 230, 210, 255),
        ),
      ),
      initialRoute: '/login', // Set the initial route to the LoginSignup screen
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => LoginSignup(),
        '/create': (context) => CreateRecipe(),
        '/shopping': (context) => ShoppingList(),
        '/recipes': (context) => RecipeList(),
        '/profile': (context) => UserProfile(),
        '/ownerProfile': (context) => RecipeOwnerProfile(),
        '/search': (context) => SearchFilter(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => RecipeDetails(
              recipeName: args['recipeName']!,
              recipeAuthor: args['recipeAuthor']!,
              instructions: args['instructions']!,
            ),
          );
        }
        return null;
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    HomePage(),
    CreateRecipe(),
    ShoppingList(),
    RecipeList(),
    UserProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Keep all pages in memory for smooth transitions
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}