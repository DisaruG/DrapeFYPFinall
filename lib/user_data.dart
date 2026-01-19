class UserData {
  static bool hasCreatedAvatar = false;

  // Measurements
  static String gender = "Male";
  static double height = 170;
  static double weight = 65;
  static double chest = 90;
  static double waist = 75;
  static double shoulder = 40;
  static String skinToneHex = "0xFFF5D0A9";

  // --- WARDROBE SYSTEM (This was missing) ---
  static String _currentGarment = "T-Shirt";

  // The Assets Map
  static final Map<String, String> wardrobeAssets = {
    "T-Shirt": "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
    "Hoodie": "https://modelviewer.dev/shared-assets/models/RobotExpressive.glb",
    "Dress": "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
    "Jacket": "https://modelviewer.dev/shared-assets/models/RobotExpressive.glb",
  };

  // Getter for the active URL
  static String get avatarUrl => wardrobeAssets[_currentGarment] ?? wardrobeAssets["T-Shirt"]!;

  // Setter to change outfit
  static void changeOutfit(String garmentName) {
    if (wardrobeAssets.containsKey(garmentName)) {
      _currentGarment = garmentName;
    }
  }

  // --- THE TRANSLATION LOGIC (Math) ---
  static double get calculatedWidthScale {
    if (weight <= 70) return 1.0;
    double extraWeight = weight - 70;
    double scale = 1.0 + (extraWeight * 0.005);
    return scale.clamp(1.0, 1.3);
  }

  static double get calculatedHeightScale {
    double scale = height / 170.0;
    return scale.clamp(0.9, 1.2);
  }

  static String get bmiString {
    double heightM = height / 100;
    if (heightM == 0) return "0.0";
    double bmi = weight / (heightM * heightM);
    return bmi.toStringAsFixed(1);
  }
}