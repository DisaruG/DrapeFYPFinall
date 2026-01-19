import 'package:flutter/material.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  // Navigation State
  // Steps: 0 = Gender, 1 = Age, 2 = Method, 3 = Input
  int _currentStep = 0;

  // User Data State
  String? _selectedGender;
  double _selectedAge = 22;
  String? _selectedMethod;

  // Detailed Measurement Data (Defaults based on average sizes)
  double _heightVal = 170;   // cm
  double _weightVal = 65;    // kg
  double _chestVal = 90;     // cm
  double _waistVal = 75;     // cm
  double _shoulderVal = 40;  // cm

  Color _selectedSkinColor = const Color(0xFFF5D0A9);

  // Skin Tone Options
  final List<Color> _skinTones = [
    const Color(0xFFF5D0A9), // Light
    const Color(0xFFE0AC69), // Medium Light
    const Color(0xFFC68642), // Medium
    const Color(0xFF8D5524), // Medium Dark
    const Color(0xFF583E2A), // Dark
    const Color(0xFF2E1D13), // Very Dark
  ];

  @override
  Widget build(BuildContext context) {
    double progress = (_currentStep + 1) / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Avatar'),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _currentStep--;
            });
          },
        )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Bar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: _buildCurrentStep(),
                ),
              ),
            ),

            // Bottom Navigation Area
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // --- STEP CONTENT BUILDERS ---

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildGenderStep();
      case 1:
        return _buildAgeStep();
      case 2:
        return _buildMethodStep();
      case 3:
        return _buildInputStep();
      default:
        return const Center(child: Text("Error"));
    }
  }

  // STEP 1: GENDER SELECTION
  Widget _buildGenderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What is your gender?",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Used to personalize avatar creation and clothing suggestions.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 40),

        _buildGenderTile("Male"),
        const SizedBox(height: 15),
        _buildGenderTile("Female"),
        const SizedBox(height: 15),
        _buildGenderTile("Other"),
      ],
    );
  }

  // STEP 2: AGE SELECTION
  Widget _buildAgeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How old are you?",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "This helps us adjust the avatar's body proportions.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 60),

        Center(
          child: Column(
            children: [
              Text(
                "${_selectedAge.round()}",
                style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent
                ),
              ),
              const Text("years old"),
            ],
          ),
        ),
        const SizedBox(height: 40),

        Slider(
          value: _selectedAge,
          min: 13,
          max: 80,
          divisions: 67,
          activeColor: Colors.blueAccent,
          onChanged: (double value) {
            setState(() {
              _selectedAge = value;
            });
          },
        ),
      ],
    );
  }

  // STEP 3: METHOD SELECTION
  Widget _buildMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose a method",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "How would you like to build your body model?",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 40),

        _buildMethodOption(
          id: 'photo',
          title: "Take a Photo",
          subtitle: "Quickest. Requires good lighting.",
          icon: Icons.camera_alt,
        ),
        const SizedBox(height: 15),
        _buildMethodOption(
          id: 'measurements',
          title: "Enter Measurements",
          subtitle: "Detailed control (Height, Chest, etc).",
          icon: Icons.straighten,
        ),
      ],
    );
  }

  // STEP 4: DETAILED MEASUREMENTS FORM
  Widget _buildInputStep() {
    if (_selectedMethod == 'photo') {
      return _buildCameraMock();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Body Measurements",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Accurate measurements ensure the best virtual fit.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),

        // --- BASIC STATS ---
        _buildMeasurementSlider(
          label: "Height",
          value: _heightVal,
          min: 140, max: 220,
          unit: "cm",
          onChanged: (val) => setState(() => _heightVal = val),
        ),
        const SizedBox(height: 20),

        _buildMeasurementSlider(
          label: "Weight",
          value: _weightVal,
          min: 40, max: 150,
          unit: "kg",
          onChanged: (val) => setState(() => _weightVal = val),
        ),
        const SizedBox(height: 20),

        // --- DETAILED STATS ---
        const Divider(color: Colors.grey),
        const SizedBox(height: 20),

        _buildMeasurementSlider(
          label: "Chest Size",
          value: _chestVal,
          min: 70, max: 150,
          unit: "cm",
          onChanged: (val) => setState(() => _chestVal = val),
        ),
        const SizedBox(height: 20),

        _buildMeasurementSlider(
          label: "Waist Size",
          value: _waistVal,
          min: 50, max: 130,
          unit: "cm",
          onChanged: (val) => setState(() => _waistVal = val),
        ),
        const SizedBox(height: 20),

        _buildMeasurementSlider(
          label: "Shoulder Width",
          value: _shoulderVal,
          min: 30, max: 60,
          unit: "cm",
          onChanged: (val) => setState(() => _shoulderVal = val),
        ),

        const SizedBox(height: 40),

        // --- SKIN TONE ---
        const Text(
          "Skin Tone",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _skinTones.map((color) {
            bool isSelected = _selectedSkinColor == color;
            return GestureDetector(
              onTap: () => setState(() => _selectedSkinColor = color),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.blueAccent, width: 3)
                      : Border.all(color: Colors.grey[800]!, width: 1),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildGenderTile(String label) {
    bool isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey[700]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.blueAccent : Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? Colors.blueAccent : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodOption({
    required String id, required String title, required String subtitle, required IconData icon
  }) {
    bool isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purpleAccent.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.purpleAccent : Colors.grey[700]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: isSelected ? Colors.purpleAccent : Colors.white),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: Colors.white)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.purpleAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementSlider({
    required String label, required double value, required double min, required double max, required String unit, required Function(double) onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(
              "${value.round()} $unit",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: Colors.blueAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCameraMock() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[800]!)),
            child: const Icon(Icons.camera_alt, size: 60, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Text("Camera access would open here"),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    bool isNextEnabled = false;
    if (_currentStep == 0 && _selectedGender != null) isNextEnabled = true;
    if (_currentStep == 1) isNextEnabled = true;
    if (_currentStep == 2 && _selectedMethod != null) isNextEnabled = true;
    if (_currentStep == 3) isNextEnabled = true;

    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[900],
            disabledForegroundColor: Colors.grey[600],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: isNextEnabled
              ? () {
            if (_currentStep < 3) {
              setState(() { _currentStep++; });
            } else {
              // Final Data Print
              print("--- AVATAR DATA ---");
              print("Gender: $_selectedGender");
              print("Age: ${_selectedAge.round()}");
              print("Height: ${_heightVal.round()}");
              print("Chest: ${_chestVal.round()}");
              print("Shoulder: ${_shoulderVal.round()}");
            }
          }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_currentStep == 3 ? "Create Avatar" : "Next", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}