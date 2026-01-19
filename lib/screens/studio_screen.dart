import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  // Research Feature: The Toggle
  bool _isEnhancedDrape = false;

  // Selected Garment Index
  int _selectedGarmentIndex = 0;

  // For the Prototype, we use a fixed Avatar URL.
  // In the full app, this would come from the AvatarScreen data.
  final String _avatarUrl = "https://modelviewer.dev/shared-assets/models/Astronaut.glb";

  // Dummy Garments
  final List<String> _garments = [
    "T-Shirt",
    "Summer Dress",
    "Hoodie",
    "Jacket"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. THE 3D AVATAR VIEWER
          // We wrap it in a container to give it a background
          Container(
            color: Colors.grey[900], // Dark background for gaming feel
            child: ModelViewer(
              src: _avatarUrl,
              alt: "A 3D model of your avatar",
              ar: false, // Turn off AR for now
              autoRotate: false,
              cameraControls: true, // Allow user to rotate/zoom
              backgroundColor: Colors.transparent,
            ),
          ),

          // 2. THE RESEARCH TOGGLE (Top Center)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Standard",
                      style: TextStyle(
                        color: !_isEnhancedDrape ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: _isEnhancedDrape,
                      activeColor: Colors.blueAccent,
                      onChanged: (value) {
                        setState(() {
                          _isEnhancedDrape = value;
                        });

                        // Research validation:
                        if (_isEnhancedDrape) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Drape Model Activated: Generating Realistic Folds..."),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    ),
                    Text(
                      "Enhanced Drape",
                      style: TextStyle(
                        color: _isEnhancedDrape ? Colors.blueAccent : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. THE GARMENT SELECTOR (Bottom)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 140,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: _garments.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedGarmentIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGarmentIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      width: 80,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(15),
                        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      ),
                      child: Center(
                        child: Text(
                          _garments[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}