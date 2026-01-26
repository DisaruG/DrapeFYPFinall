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

  // --- WARDROBE SYSTEM ---

  // GUARANTEED PUBLIC URLS (Do not change these)
  static const String _maleBase = "https://models.readyplayer.me/64b73b54435559443c512316.glb";
  static const String _femaleBase = "https://models.readyplayer.me/64b73c3d435559443c512335.glb";

  // Wardrobe Map
  static final Map<String, String> maleWardrobe = {
    "T-Shirt": _maleBase,
    "Hoodie": _maleBase,
    "Jacket": _maleBase,
    "Dress": _maleBase,
  };

  static final Map<String, String> femaleWardrobe = {
    "T-Shirt": _femaleBase,
    "Hoodie": _femaleBase,
    "Dress": _femaleBase,
    "Jacket": _femaleBase,
  };

  // Getter
  static String get avatarUrl {
    return (gender == "Female") ? _femaleBase : _maleBase;
  }

  // Setter
  static void changeOutfit(String garmentName) {
  }

  // --- MORPHING ALGORITHM ---
  static double get calculatedWidthScale {
    if (weight <= 50) return 0.95;
    double extraWeight = weight - 70;
    double scale = 1.0 + (extraWeight * 0.004);
    return scale.clamp(0.9, 1.25);
  }

  static double get calculatedHeightScale {
    double scale = height / 170.0;
    return scale.clamp(0.92, 1.15);
  }

  static String get bmiString {
    double heightM = height / 100;
    if (heightM == 0) return "0.0";
    double bmi = weight / (heightM * heightM);
    return bmi.toStringAsFixed(1);
  }
}