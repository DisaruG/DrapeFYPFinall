import 'package:flutter/material.dart';
import '../user_data.dart';
import '../main.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  // Navigation State
  int _currentStep = 0;

  // Local State for the Form
  String? _selectedGender;
  double _selectedAge = 22;
  String? _selectedMethod;

  // Measurements
  double _heightVal = 170;
  double _weightVal = 65;
  double _chestVal = 90;
  double _waistVal = 75;
  double _shoulderVal = 40;
  Color _selectedSkinColor = const Color(0xFFF5D0A9);

  final List<Color> _skinTones = [
    const Color(0xFFF5D0A9), const Color(0xFFE0AC69), const Color(0xFFC68642),
    const Color(0xFF8D5524), const Color(0xFF583E2A), const Color(0xFF2E1D13),
  ];

  @override
  Widget build(BuildContext context) {
    if (UserData.hasCreatedAvatar) {
      return _buildProfileDashboard();
    } else {
      return _buildWizard();
    }
  }

  // ==========================================
  // MODE B: THE PROFILE DASHBOARD (Existing User)
  // ==========================================
  Widget _buildProfileDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              setState(() {
                UserData.hasCreatedAvatar = false;
                _currentStep = 0;
              });
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),

              Text(
                "${UserData.gender} • ${UserData.height.round()} cm",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Digital Twin Active",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  children: [
                    _buildStatRow("Weight", "${UserData.weight.round()} kg"),
                    const Divider(color: Colors.grey),
                    _buildStatRow("Chest", "${UserData.chest.round()} cm"),
                    const Divider(color: Colors.grey),
                    _buildStatRow("Waist", "${UserData.waist.round()} cm"),
                    const Divider(color: Colors.grey),
                    _buildStatRow("Shoulder", "${UserData.shoulder.round()} cm"),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Measurements"),
                  onPressed: () {
                    setState(() {
                      UserData.hasCreatedAvatar = false;
                      _currentStep = 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  // ==========================================
  // MODE A: THE WIZARD (New User)
  // ==========================================
  Widget _buildWizard() {
    double progress = (_currentStep + 1) / 4;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Avatar'),
        centerTitle: true,
        leading: _currentStep > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _currentStep--),
        )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(child: _buildCurrentStep()),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // --- WIZARD STEPS ---
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildGenderStep();
      case 1: return _buildAgeStep();
      case 2: return _buildMethodStep();
      case 3: return _buildInputStep();
      default: return const Center(child: Text("Error"));
    }
  }

  // Step 0: Gender
  Widget _buildGenderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("What is your gender?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Used to personalize avatar creation.", style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 40),
        _buildGenderTile("Male"),
        const SizedBox(height: 15),
        _buildGenderTile("Female"),
        const SizedBox(height: 15),
        _buildGenderTile("Other"),
      ],
    );
  }

  // Step 1: Age
  Widget _buildAgeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("How old are you?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("This helps us adjust the avatar's body proportions.", style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 60),
        Center(child: Text("${_selectedAge.round()}", style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.blueAccent))),
        Slider(value: _selectedAge, min: 13, max: 80, divisions: 67, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => _selectedAge = v)),
      ],
    );
  }

  // Step 2: Method (RESTORED TEXT)
  Widget _buildMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Choose a method", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        // RESTORED SUBTITLE BELOW
        const Text("How would you like to build your body model?", style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 40),

        _buildMethodOption(id: 'photo', title: "Take a Photo", subtitle: "Quickest. Requires good lighting.", icon: Icons.camera_alt),
        const SizedBox(height: 15),
        _buildMethodOption(id: 'measurements', title: "Enter Measurements", subtitle: "Detailed control.", icon: Icons.straighten),
      ],
    );
  }

  // Step 3: Input (RESTORED TEXT)
  Widget _buildInputStep() {
    if (_selectedMethod == 'photo') return const Center(child: Icon(Icons.camera_alt, size: 60, color: Colors.grey));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RESTORED TITLE & SUBTITLE
        const Text("Body Measurements", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Accurate measurements ensure the best virtual fit.", style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 30),

        _buildSlider("Height", _heightVal, 140, 220, "cm", (v) => setState(() => _heightVal = v)),
        const SizedBox(height: 20),
        _buildSlider("Weight", _weightVal, 40, 150, "kg", (v) => setState(() => _weightVal = v)),
        const SizedBox(height: 20),
        const Divider(),
        _buildSlider("Chest", _chestVal, 70, 150, "cm", (v) => setState(() => _chestVal = v)),
        const SizedBox(height: 20),
        _buildSlider("Waist", _waistVal, 50, 130, "cm", (v) => setState(() => _waistVal = v)),
        const SizedBox(height: 20),
        _buildSlider("Shoulder", _shoulderVal, 30, 60, "cm", (v) => setState(() => _shoulderVal = v)),

        const SizedBox(height: 30),
        const Text("Skin Tone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
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
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- HELPERS ---
  Widget _buildGenderTile(String label) {
    bool isSelected = _selectedGender == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = label),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.grey[700]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [Text(label, style: const TextStyle(fontSize: 18)), const Spacer(), Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? Colors.blueAccent : Colors.grey)]),
      ),
    );
  }

  Widget _buildMethodOption({required String id, required String title, required String subtitle, required IconData icon}) {
    bool isSelected = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purpleAccent.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.purpleAccent : Colors.grey[700]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [Icon(icon, color: isSelected ? Colors.purpleAccent : Colors.white), const SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold)), Text(subtitle, style: TextStyle(color: Colors.grey[400]))])]),
      ),
    );
  }

  Widget _buildSlider(String label, double val, double min, double max, String unit, Function(double) onChange) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text("${val.round()} $unit", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))]),
      Slider(value: val, min: min, max: max, divisions: (max - min).toInt(), activeColor: Colors.blueAccent, onChanged: onChange),
    ]);
  }

  Widget _buildBottomBar() {
    bool isNext = (_currentStep == 0 && _selectedGender != null) || _currentStep == 1 || (_currentStep == 2 && _selectedMethod != null) || _currentStep == 3;
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
          onPressed: isNext ? () {
            if (_currentStep < 3) {
              setState(() => _currentStep++);
            } else {
              // FINISH
              UserData.hasCreatedAvatar = true;
              UserData.gender = _selectedGender!;
              UserData.height = _heightVal;
              UserData.weight = _weightVal;
              UserData.chest = _chestVal;
              UserData.waist = _waistVal;
              UserData.shoulder = _shoulderVal;

              final state = context.findAncestorStateOfType<MainWrapperState>();
              state?.switchToTab(1); // Go to Studio
            }
          } : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentStep == 3 ? "Create Avatar" : "Next",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}