import 'package:flutter/material.dart';
import 'dart:async';

class CameraMockScreen extends StatefulWidget {
  final Function() onAnalysisComplete;

  const CameraMockScreen({super.key, required this.onAnalysisComplete});

  @override
  State<CameraMockScreen> createState() => _CameraMockScreenState();
}

class _CameraMockScreenState extends State<CameraMockScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnalyzing = true;
  String _statusText = "Initializing Computer Vision...";

  @override
  void initState() {
    super.initState();
    // 1. Setup the Scanning Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 2. Simulate the AI "Thinking" Process
    _startSimulation();
  }

  void _startSimulation() async {
    // Sequence of fake AI statuses
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusText = "Detecting Body Landmarks...");

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusText = "Calculating Shoulder Width...");

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _statusText = "Estimating Volume...");

    await Future.delayed(const Duration(seconds: 1));
    // 3. Finish
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _statusText = "Analysis Complete.";
      });
      _controller.stop();

      // 4. Show Result Dialog
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Scan Successful", style: TextStyle(color: Colors.greenAccent)),
        content: const Text(
          "Neural Network has estimated your measurements.\nPlease verify them on the next screen.",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close Dialog
              Navigator.pop(context); // Close Camera Screen
              widget.onAnalysisComplete(); // Trigger the autofill
            },
            child: const Text("Proceed", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fake Camera Feed (Placeholder Image or Dark Grey)
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.grey[800]!, Colors.grey[900]!],
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 300, color: Colors.black26),
            ),
          ),

          // 2. The Scanning Line (FIXED SECTION)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).size.height * 0.2 +
                    (_controller.value * 400), // Moves 400px down
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  // FIX: BoxShadow must be inside BoxDecoration
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          // 3. HUD Overlay (Text)
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text("REC", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  color: Colors.black54,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    _statusText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: "Courier",
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }
}