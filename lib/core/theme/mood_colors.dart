import 'package:flutter/material.dart';

class MoodColors {
  static const Map<String, Color> moodColorMap = {
    'joy': Color(0xFFFFD93D),
    'happy': Color(0xFFFFB84D),
    'neutral': Color(0xFF95D5B2),
    'sad': Color(0xFF74C0FC),
    'stressed': Color(0xFFFF6B6B),
    'anxious': Color(0xFFAE8ED6),
    'calm': Color(0xFF84D7E8),
    'angry': Color(0xFFFA5252),
  };

  static Color getColorForMood(String mood) {
    return moodColorMap[mood.toLowerCase()] ?? const Color(0xFF95D5B2);
  }

  static LinearGradient getGradientForMood(String mood) {
    Color primary = getColorForMood(mood);
    Color secondary = primary.withOpacity(0.6);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, secondary],
    );
  }
}