import 'package:flutter/material.dart';
import 'dart:async';

class CameraMockScreen extends StatefulWidget {
  final Function() onAnalysisComplete;

  const CameraMockScreen({super.key, required this.onAnalysisComplete});

  @override
  State<CameraMockScreen> createState() => _CameraMockScreenState();
}

class _CameraMockScreenState extends State<CameraMockScreen> with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;

  bool _isAnalyzing = true;
  String _statusText = "INITIALIZING SENSORS...";

  @override
  void initState() {
    super.initState();

    // 1. Scanner Line Animation (Up and Down)
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 2. Bracket Pulsing Animation (Breathing effect)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _startSimulation();
  }

  void _startSimulation() async {
    // Fake AI Steps with professional messaging
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusText = "IDENTIFYING KEYPOINTS...");

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusText = "CALCULATING DEPTH...");

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _statusText = "SCAN COMPLETE";
      });
      _scanController.stop();
      _pulseController.stop();

      // 3. Show sleek bottom sheet (Matching App Theme)
      _showResultSheet();
    }
  }

  void _showResultSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.blueAccent, size: 60),
            const SizedBox(height: 20),
            const Text(
              "Scan Successful",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // --- UPDATED TEXT HERE ---
            const Text(
              "We've estimated your measurements. Please review them to ensure the best fit.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16), // Slightly larger font for readability
            ),
            // -------------------------
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                  widget.onAnalysisComplete();
                },
                child: const Text("Review Measurements", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera feed is always black/dark
      body: Stack(
        children: [
          // 1. Camera Placeholder (Deep Black)
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xFF0A0A0A),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 150, color: Colors.grey[800]),
                  const SizedBox(height: 20),
                  Text("Align body within frame", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                ],
              ),
            ),
          ),

          // 2. The Focus Brackets (App Theme Blue)
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 300,
                  height: 480,
                  decoration: BoxDecoration(
                    border: Border.all(
                      // Pulsing Blue Effect
                        color: Colors.blueAccent.withOpacity(0.3 + (_pulseController.value * 0.4)),
                        width: 2
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Corners
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCorner(0), // Top Left
                          _buildCorner(1), // Top Right
                        ],
                      ),
                      // Bottom Corners
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCorner(3), // Bottom Left
                          _buildCorner(2), // Bottom Right
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 3. The Scanner Line (Blue Laser)
          if (_isAnalyzing)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.15 + (_scanController.value * 500),
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      boxShadow: [
                        BoxShadow(color: Colors.blueAccent.withOpacity(0.6), blurRadius: 15, spreadRadius: 2)
                      ],
                    ),
                  ),
                );
              },
            ),

          // 4. Header with Close Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[900],
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        const Text("AI VISION ACTIVE", style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Status Text (Floating at bottom)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _statusText,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontFamily: "Courier",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the corner brackets
  Widget _buildCorner(int quarter) {
    // 0=TL, 1=TR, 2=BR, 3=BL
    return RotatedBox(
      quarterTurns: quarter,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.blueAccent, width: 4),
            left: BorderSide(color: Colors.blueAccent, width: 4),
          ),
        ),
      ),
    );
  }
}