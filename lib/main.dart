import 'package:chef_buddy/firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/HomePage.dart';
import 'screens/RecipeList.dart';
import 'screens/CreateRecipe.dart';
import 'screens/ShoppingList.dart';
import 'screens/UserProfile.dart';
import 'screens/LoginSignup.dart';
import 'screens/RecipeDetails.dart';
import 'screens/RecipeOwnerProfile.dart';
import 'screens/SearchFilter.dart';
import 'widgets/CustomNavigationBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'providers/RecipeProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: const ChefBuddyApp(),
    ),
  );
}

class ChefBuddyApp extends StatelessWidget {
  const ChefBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chef Buddy',
      theme: ThemeData(
        fontFamily: 'WinkyRough',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color.fromARGB(255, 186, 104, 200),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 186, 104, 200),
          secondary: const Color.fromARGB(255, 230, 210, 255),
        ),
      ),
      home: const AuthGate(), // 👈 Replaces initialRoute for better auth flow
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
              recipeId: args['recipeId']!,
            ),
          );
        }
        return null;
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const MainScreen(); // Authenticated
        } else {
          return LoginSignup(); // Not logged in
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
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
        children: _pages,
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

