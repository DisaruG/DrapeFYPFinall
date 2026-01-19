import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../user_data.dart';
import '../main.dart'; // <--- Vital import

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  bool _isEnhancedDrape = false;
  int _selectedGarmentIndex = 0;
  final List<String> _garments = ["T-Shirt", "Summer Dress", "Hoodie", "Jacket"];

  @override
  Widget build(BuildContext context) {
    // 1. THE GATEKEEPER CHECK
    // If the user hasn't created an avatar yet, show the "Locked" screen.
    if (!UserData.hasCreatedAvatar) {
      return _buildLockedState();
    }

    // 2. THE 3D STUDIO (Only shown if unlocked)
    return Scaffold(
      body: Stack(
        children: [
          // The 3D Viewer
          Container(
            color: Colors.grey[900],
            child: ModelViewer(
              src: UserData.avatarUrl, // Uses the URL from the Profile/Tailor
              alt: "Your Digital Twin",
              ar: false,
              autoRotate: false,
              cameraControls: true,
              backgroundColor: Colors.transparent,
            ),
          ),

          // Research Toggle (Drape Mode)
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
                    Text("Standard", style: TextStyle(color: !_isEnhancedDrape ? Colors.white : Colors.grey)),
                    Switch(
                      value: _isEnhancedDrape,
                      activeColor: Colors.blueAccent,
                      onChanged: (val) => setState(() => _isEnhancedDrape = val),
                    ),
                    Text("Enhanced Drape", style: TextStyle(color: _isEnhancedDrape ? Colors.blueAccent : Colors.grey)),
                  ],
                ),
              ),
            ),
          ),

          // Garment Selector
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(20),
                itemCount: _garments.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedGarmentIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedGarmentIndex = index),
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
                          style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
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

  // --- THE LOCKED STATE WIDGET ---
  Widget _buildLockedState() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "Fitting Room Locked",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "To see how clothes fit on YOUR body, you need to create your digital twin first.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Go to Profile to Create Avatar", style: TextStyle(fontSize: 16, color: Colors.white)),
                onPressed: () {
                  // TELEPORT TO PROFILE TAB (Index 2)
                  final state = context.findAncestorStateOfType<MainWrapperState>();
                  state?.switchToTab(2);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}