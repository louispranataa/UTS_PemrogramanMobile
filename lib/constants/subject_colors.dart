// lib/constants/subject_colors.dart

import 'package:flutter/material.dart';

// Warna dominan untuk setiap mata pelajaran
class SubjectColors {
  static const Color math = Color(0xFF3B82F6); // Biru
  static const Color mathLight = Color(0xFFDBEAFE);
  static const Color mathDark = Color(0xFF1E40AF);

  static const Color biology = Color(0xFF10B981); // Hijau
  static const Color biologyLight = Color(0xFFD1FAE5);
  static const Color biologyDark = Color(0xFF047857);

  static const Color physics = Color(0xFF8B5CF6); // Ungu
  static const Color physicsLight = Color(0xFFEDE9FE);
  static const Color physicsDark = Color(0xFF6D28D9);

  static const Color chemistry = Color(0xFFF59E0B); // Oranye
  static const Color chemistryLight = Color(0xFFFEF3C7);
  static const Color chemistryDark = Color(0xFFD97706);

  // Helper method untuk mendapatkan warna berdasarkan nama mata pelajaran
  static Color getPrimaryColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematika':
        return math;
      case 'biologi':
        return biology;
      case 'fisika':
        return physics;
      case 'kimia':
        return chemistry;
      default:
        return const Color(0xFF6366F1);
    }
  }

  static Color getLightColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematika':
        return mathLight;
      case 'biologi':
        return biologyLight;
      case 'fisika':
        return physicsLight;
      case 'kimia':
        return chemistryLight;
      default:
        return const Color(0xFFE0E7FF);
    }
  }

  static Color getDarkColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'matematika':
        return mathDark;
      case 'biologi':
        return biologyDark;
      case 'fisika':
        return physicsDark;
      case 'kimia':
        return chemistryDark;
      default:
        return const Color(0xFF4F46E5);
    }
  }
}