import 'package:flutter/material.dart';

class StudentAttendanceSummary {
  final String name;
  final String id;
  final String? avatarUrl; // Use null for initials
  final double percentage;
  final int presentCount;
  final int absentCount;

  const StudentAttendanceSummary({
    required this.name,
    required this.id,
    this.avatarUrl,
    required this.percentage,
    required this.presentCount,
    required this.absentCount,
  });
}