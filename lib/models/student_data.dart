import 'package:flutter/material.dart';
import 'timetable_entry.dart';

// Model to hold all unique data for a student's dashboard
class StudentData {
  final bool hasFeeAlert;
  final double attendancePercentage;
  final double currentGpa;
  final int creditsCompleted;
  final int totalCredits;
  final TimetableEntry nextClass;
  // You would also add lists for recent activity, due work, etc.

  const StudentData({
    required this.hasFeeAlert,
    required this.attendancePercentage,
    required this.currentGpa,
    required this.creditsCompleted,
    required this.totalCredits,
    required this.nextClass,
  });
}