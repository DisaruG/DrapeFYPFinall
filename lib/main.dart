import 'package:flutter/material.dart';
import 'screens/wardrobe_screen.dart';
import 'screens/avatar_screen.dart';
import 'screens/studio_screen.dart';

void main() {
  runApp(const DrapeApp());
}

class DrapeApp extends StatelessWidget {
  const DrapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drape',
      theme: ThemeData(
        // Using a dark theme often looks more "modern" for Gen Z/Gaming apps
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  // This variable keeps track of which tab is currently selected
  // 0 = Wardrobe, 1 = Studio, 2 = Profile
  int _currentIndex = 0;

  // These are the 3 screens we will switch between.
  // For now, they are just simple placeholders with text.
  final List<Widget> _screens = [
    const WardrobeScreen(),
    const StudioScreen(), // <--- NEW SCREEN
    const AvatarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar is the title bar at the top
      // appBar: AppBar(
      //   title: const Text('Drape Prototype'),
      //   centerTitle: true,
      // ),

      // The 'body' changes based on which tab is selected
      body: _screens[_currentIndex],

      // This is the navigation bar at the bottom
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          // This code runs when you click a tab
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checkroom), // Icon for clothes
            label: 'Wardrobe',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_in_ar), // Icon for 3D/AR
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.person), // Icon for user
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}