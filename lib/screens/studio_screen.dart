import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../user_data.dart';
import '../main.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  bool _isEnhancedDrape = false;

  // The list of buttons available
  final List<String> _garments = ["T-Shirt", "Hoodie", "Dress", "Jacket"];
  String _selectedGarment = "T-Shirt";

  bool _showDebugInfo = false;

  @override
  Widget build(BuildContext context) {
    if (!UserData.hasCreatedAvatar) {
      return _buildLockedState();
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.grey[900]), // Background

          // 1. THE 3D AVATAR (Ready Player Me)
          Center(
            child: SizedBox(
              width: 400,
              height: 600,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(UserData.calculatedWidthScale, UserData.calculatedHeightScale),
                child: ModelViewer(
                  key: ValueKey(_selectedGarment + UserData.gender), // Reloads if Gender or Outfit changes
                  src: UserData.avatarUrl,
                  alt: "Your Digital Twin",
                  ar: false,
                  autoRotate: false,
                  cameraControls: true,
                  backgroundColor: Colors.transparent,
                  // NEW: Makes the avatar breathe/move if it has animations
                  autoPlay: true,
                  animationName: "Idle",
                ),
              ),
            ),
          ),

          // 2. THE HEATMAP OVERLAY
          if (_isEnhancedDrape)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.red.withOpacity(0.4),
                        Colors.yellow.withOpacity(0.3),
                        Colors.green.withOpacity(0.1),
                        Colors.transparent
                      ],
                      stops: const [0.2, 0.5, 0.8, 1.0],
                      radius: 0.8,
                    ),
                  ),
                ),
              ),
            ),

          // 3. TOP CONTROLS
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Fit Map Toggle
                Container(
                  margin: const EdgeInsets.only(left: 20, top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _isEnhancedDrape ? Colors.redAccent : Colors.grey)
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.layers, color: _isEnhancedDrape ? Colors.redAccent : Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text("Fit Map", style: TextStyle(color: _isEnhancedDrape ? Colors.redAccent : Colors.white, fontWeight: FontWeight.bold)),
                      Switch(
                        value: _isEnhancedDrape,
                        activeColor: Colors.redAccent,
                        onChanged: (val) => setState(() => _isEnhancedDrape = val),
                      ),
                    ],
                  ),
                ),

                // Debug Button
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: IconButton(
                    icon: Icon(Icons.analytics_outlined, color: _showDebugInfo ? Colors.blueAccent : Colors.white),
                    onPressed: () => setState(() => _showDebugInfo = !_showDebugInfo),
                  ),
                ),
              ],
            ),
          ),

          // 4. DEBUG PANEL
          if (_showDebugInfo)
            Positioned(
              top: 100, right: 20,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: 200,
                decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.blueAccent)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("LOGIC METRICS", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 5),
                    Text("Gender: ${UserData.gender}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    Text("Weight: ${UserData.weight.round()} kg", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    Text("BMI: ${UserData.bmiString}", style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 5),
                    Text("Outfit: $_selectedGarment", style: const TextStyle(color: Colors.cyanAccent, fontSize: 12)),
                  ],
                ),
              ),
            ),

          // 5. LEGEND
          if (_isEnhancedDrape)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem(Colors.redAccent, "Tight"),
                    _buildLegendItem(Colors.yellow, "Comfort"),
                    _buildLegendItem(Colors.green, "Loose"),
                  ],
                ),
              ),
            ),

          // 6. GARMENT SELECTOR
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black, Colors.transparent]),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                itemCount: _garments.length,
                itemBuilder: (context, index) {
                  String garment = _garments[index];
                  bool isSelected = _selectedGarment == garment;

                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[800],
                        foregroundColor: Colors.white,
                        side: isSelected ? const BorderSide(color: Colors.white, width: 2) : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedGarment = garment;
                          UserData.changeOutfit(garment);
                        });
                      },
                      child: Text(garment),
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

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildLockedState() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("Studio Locked", style: TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              onPressed: () {
                final state = context.findAncestorStateOfType<MainWrapperState>();
                state?.switchToTab(2);
              },
              child: const Text("Go to Profile to Create Avatar"),
            )
          ],
        ),
      ),
    );
  }
}