import 'package:flutter/material.dart';

enum DueWorkStatus { pending, completed }

class DueWorkItem {
  final String title;
  final String course;
  final IconData icon;
  final DueWorkStatus status;
  final DateTime? dueDate;
  final DateTime? completedDate;


  const DueWorkItem({
    required this.title,
    required this.course,
    required this.icon,
    required this.status,
    this.dueDate,
    this.completedDate,
  });
}