// lib/models/timetable_entry.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableEntry {
  final String course;
  final String professor;
  final String location;
  final String startTime; // e.g., "09:00 AM"
  final String endTime;   // e.g., "10:00 AM"
  final Color color;    // New: For color-coding courses

  const TimetableEntry({
    required this.course,
    required this.professor,
    required this.location,
    required this.startTime,
    required this.endTime,
    this.color = Colors.blue, // Default color
  });

  // Helper to parse start time for comparison
  TimeOfDay get startTimeOfDay {
    final format = DateFormat('h:mm a'); // Handles "09:00 AM"
    final dt = format.parse(startTime);
    return TimeOfDay.fromDateTime(dt);
  }

  // Helper to parse end time for comparison
  TimeOfDay get endTimeOfDay {
    final format = DateFormat('h:mm a');
    final dt = format.parse(endTime);
    return TimeOfDay.fromDateTime(dt);
  }
}