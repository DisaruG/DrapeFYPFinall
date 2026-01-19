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
  State<MainWrapper> createState() => MainWrapperState();
}

class MainWrapperState extends State<MainWrapper> {
  // This variable keeps track of which tab is currently selected
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WardrobeScreen(),
    const StudioScreen(),
    const AvatarScreen(),
  ];

  // --- THIS WAS MISSING ---
  // This function allows other screens (like AvatarScreen) to change the tab.
  void switchToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  // ------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.checkroom),
            label: 'Wardrobe',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_in_ar),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}