// lib/models/subject_model.dart

import 'package:flutter/material.dart';

class Subject {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color lightColor;

  Subject({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.lightColor,
  });
}