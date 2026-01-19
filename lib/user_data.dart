class UserData {
  // Lock Status
  static bool hasCreatedAvatar = false;

  // Measurements
  static String gender = "Male";
  static double height = 170;
  static double weight = 65;
  static double chest = 90;
  static double waist = 75;
  static double shoulder = 40;
  static String skinToneHex = "0xFFF5D0A9";

  // The Base Model (Astronaut)
  static String avatarUrl = "https://modelviewer.dev/shared-assets/models/Astronaut.glb";

  // --- THE TRANSLATION LOGIC (The "Math") ---

  // 1. Width Scale (Simulating Weight/Muscle)
  // If weight > 70kg, we widen the model.
  // Max width increase is 30% (1.3x) to prevent distortion.
  static double get calculatedWidthScale {
    if (weight <= 70) return 1.0;
    double extraWeight = weight - 70;
    double scale = 1.0 + (extraWeight * 0.005);
    return scale.clamp(1.0, 1.3);
  }

  // 2. Height Scale (Simulating Stature)
  // Standard height is 170cm.
  static double get calculatedHeightScale {
    double scale = height / 170.0;
    return scale.clamp(0.9, 1.2); // Limit ranges
  }

  // 3. BMI Calculator for the Debug Tab
  static String get bmiString {
    double heightM = height / 100;
    if (heightM == 0) return "0.0";
    double bmi = weight / (heightM * heightM);
    return bmi.toStringAsFixed(1);
  }
}