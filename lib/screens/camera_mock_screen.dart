import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Required for the iOS Spinner
import 'dart:async';
import 'dart:ui'; // Required for the Blur Effect

class CameraMockScreen extends StatefulWidget {
  final Function() onAnalysisComplete;

  const CameraMockScreen({super.key, required this.onAnalysisComplete});

  @override
  State<CameraMockScreen> createState() => _CameraMockScreenState();
}

class _CameraMockScreenState extends State<CameraMockScreen> {
  // State
  bool _isProcessing = false;
  String _statusText = "";

  void _takePicture() async {
    setState(() {
      _isProcessing = true;
      _statusText = "Processing...";
    });

    // Phase 1: Upload/Process delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _statusText = "Identifying Keypoints...");

    // Phase 2: AI Calculation delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusText = "Calculating Dimensions...");

    // Phase 3: Finish
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
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
            const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 60),
            const SizedBox(height: 20),
            const Text(
              "Analysis Complete",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Image processed successfully. We have estimated your measurements based on the reference points.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
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
                child: const Text("View Results", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Preview (Simulated)
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xFF111111),
            child: const Center(
              child: Icon(Icons.person, size: 100, color: Colors.white10),
            ),
          ),

          // 2. Simple Guide Frame (Static)
          Center(
            child: Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white30, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (!_isProcessing) // Hide text when loading to keep it clean
                    const Text(
                      "ALIGN BODY IN FRAME",
                      style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                ],
              ),
            ),
          ),

          // 3. IOS 14 STYLE LOADING HUD
          if (_isProcessing)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // The Glass Effect
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[800]!.withOpacity(0.7), // Semi-transparent grey
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CupertinoActivityIndicator(
                          radius: 20, // Nice large iOS spinner
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _statusText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 4. Camera Controls (Bottom)
          if (!_isProcessing)
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // Bottom Shutter Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 5),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Container(
                            width: 65,
                            height: 65,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}