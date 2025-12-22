// lib/models/grade_item.dart
import 'package:flutter/material.dart';

// Represents a single graded item (e.g., Midterm, Quiz 1)
class GradeItem {
  final String title;
  final String grade; // e.g., "85/100" or "A+"

  const GradeItem({
    required this.title,
    required this.grade,
  });
}