// lib/data/timetable_db.dart
import '../models/timetable_entry.dart';
import 'package:flutter/material.dart';

// --- Define Course Colors ---
const Color mathColor = Color(0xFFE53935);    // Red (Math)
const Color hardwareColor = Color(0xFF1E88E5); // Blue (Digital/Hardware)
const Color circuitsColor = Color(0xFF43A047); // Green (Electronics)
const Color softSkillsColor = Color(0xFFFB8C00); // Orange (Development)
const Color labColor = Color(0xFF8E24AA);     // Purple (Labs)
const Color ethicsColor = Color(0xFF6D4C41);   // Brown (Ethics/Values)

final Map<int, List<TimetableEntry>> weeklyTimetableData = {
  // --- MONDAY ---
  DateTime.monday: const [
    TimetableEntry(
      course: 'Advanced Mathematics-III',
      professor: 'Dr. Sarah Jenkins',
      location: 'Hall 101',
      startTime: '09:00 AM',
      endTime: '10:00 AM',
      color: mathColor,
    ),
    TimetableEntry(
      course: 'Digital Electronics',
      professor: 'Prof. Marcus Thorne',
      location: 'Lab 202',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      color: hardwareColor,
    ),
    TimetableEntry(
      course: 'Circuit Theory',
      professor: 'Dr. Elena Vance',
      location: 'Hall 101',
      startTime: '11:00 AM',
      endTime: '12:00 PM',
      color: circuitsColor,
    ),
    TimetableEntry(
      course: 'Ethics & Values',
      professor: 'Dr. Robert Miller',
      location: 'Auditorium',
      startTime: '01:00 PM',
      endTime: '02:00 PM',
      color: ethicsColor,
    ),
  ],

  // --- TUESDAY ---
  DateTime.tuesday: const [
    TimetableEntry(
      course: 'Digital Electronics',
      professor: 'Prof. Marcus Thorne',
      location: 'Lab 202',
      startTime: '09:00 AM',
      endTime: '10:00 AM',
      color: hardwareColor,
    ),
    TimetableEntry(
      course: 'Skill Development',
      professor: 'Prof. Chloe Williams',
      location: 'Hall 101',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      color: softSkillsColor,
    ),
    TimetableEntry(
      course: 'Circuit Theory',
      professor: 'Dr. Elena Vance',
      location: 'Hall 101',
      startTime: '11:00 AM',
      endTime: '12:00 PM',
      color: circuitsColor,
    ),
    TimetableEntry(
      course: 'Circuits Lab (Practical)',
      professor: 'Dr. Elena Vance',
      location: 'Main Electronics Lab',
      startTime: '02:00 PM',
      endTime: '04:00 PM',
      color: labColor,
    ),
  ],

  // --- WEDNESDAY ---
  DateTime.wednesday: const [
    TimetableEntry(
      course: 'Advanced Mathematics-III',
      professor: 'Dr. Sarah Jenkins',
      location: 'Hall 101',
      startTime: '09:00 AM',
      endTime: '10:00 AM',
      color: mathColor,
    ),
    TimetableEntry(
      course: 'Digital Electronics',
      professor: 'Prof. Marcus Thorne',
      location: 'Lab 202',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      color: hardwareColor,
    ),
    TimetableEntry(
      course: 'Professional Development',
      professor: 'Prof. Chloe Williams',
      location: 'Comm Center',
      startTime: '02:00 PM',
      endTime: '04:00 PM',
      color: softSkillsColor,
    ),
  ],

  // --- THURSDAY ---
  DateTime.thursday: const [
    TimetableEntry(
      course: 'Ethics & Values',
      professor: 'Dr. Robert Miller',
      location: 'Auditorium',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      color: ethicsColor,
    ),
    TimetableEntry(
      course: 'Circuit Theory',
      professor: 'Dr. Elena Vance',
      location: 'Hall 101',
      startTime: '11:00 AM',
      endTime: '12:00 PM',
      color: circuitsColor,
    ),
    TimetableEntry(
      course: 'Digital Practical',
      professor: 'Prof. Marcus Thorne',
      location: 'Digital Lab',
      startTime: '02:00 PM',
      endTime: '04:00 PM',
      color: labColor,
    ),
  ],

  // --- FRIDAY ---
  DateTime.friday: const [
    TimetableEntry(
      course: 'Advanced Mathematics-III',
      professor: 'Dr. Sarah Jenkins',
      location: 'Hall 101',
      startTime: '09:00 AM',
      endTime: '10:00 AM',
      color: mathColor,
    ),
    TimetableEntry(
      course: 'Skill Development',
      professor: 'Prof. Chloe Williams',
      location: 'Hall 105',
      startTime: '10:00 AM',
      endTime: '11:00 AM',
      color: softSkillsColor,
    ),
  ],

  DateTime.saturday: [],
  DateTime.sunday: [],
};