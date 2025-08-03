import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  // Weather API
  static const String weatherApiKey = '2b70b5cf01202e19f85eb9bc17f98ade';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Default units
  static const String defaultUnit = 'metric'; // or 'imperial'

  // SharedPrefs Keys
  static const String onboardingSeenKey = 'onboarding_seen';
  static const String themePrefKey = 'is_dark_mode';
  static const String unitPrefKey = 'unit';
  static const String favoriteCitiesKey = 'favorite_cities';
  static const String notificationPrefKey = 'notificationsEnabled';
}

/// Padding and spacing
class AppPadding {
  static const double screen = 16.0;
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 24.0;
}

/// Color palette (override by theme if needed)
class AppColors {
  static const Color sunny = Color(0xFFFFD54F);
  static const Color cloudy = Color(0xFF90A4AE);
  static const Color rainy = Color(0xFF4FC3F7);
  static const Color night = Color(0xFF263238);
}
