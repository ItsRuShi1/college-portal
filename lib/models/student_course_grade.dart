import 'package:flutter/material.dart';

class StudentCourseGrade {
  final String title;
  final String code;
  final int credits;
  final String finalGrade;
  final IconData icon;

  const StudentCourseGrade({
    required this.title,
    required this.code,
    required this.credits,
    required this.finalGrade,
    required this.icon,
  });
}