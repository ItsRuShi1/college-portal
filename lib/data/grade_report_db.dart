import '../models/student_course_grade.dart';
import '../models/grade_report.dart';
import 'package:flutter/material.dart';

// --- Reusable Course Definitions ---
// (Grades are now consistent with a 10-point system)
const _edc = StudentCourseGrade(title: 'Electronics Devices and Circuit', code: 'EDC', credits: 4, finalGrade: 'A', icon: Icons.memory);
const _em3 = StudentCourseGrade(title: 'Engineering Mathematics-III', code: 'EM-III', credits: 3, finalGrade: 'B+', icon: Icons.calculate);
const _de = StudentCourseGrade(title: 'Digital Electronics', code: 'DE', credits: 4, finalGrade: 'A-', icon: Icons.developer_board);
const _esd = StudentCourseGrade(title: 'Employability & Skill Dev.', code: 'E&SD', credits: 2, finalGrade: 'A', icon: Icons.work);
const _pd = StudentCourseGrade(title: 'Personality Development', code: 'PD', credits: 1, finalGrade: 'A+', icon: Icons.person);
const _uhv = StudentCourseGrade(title: 'Universal Human Value', code: 'UHV-1', credits: 3, finalGrade: 'B', icon: Icons.public);


const _report1 = GradeReport(
    termGpa: 9.2, // Changed from 3.85
    overallGrade: 'A',
    gpaMessage: "Great work! You're on track for the Dean's List.",
    grades: [
      _edc, // Grade: A
      _em3, // Grade: B+
      _de, // Grade: A-
      _esd, // Grade: A
      _pd, // Grade: A+
      _uhv, // Grade: B
    ]
);


const _report2 = GradeReport(
    termGpa: 8.5, // Changed from 3.50
    overallGrade: 'B+',
    gpaMessage: "Solid performance! Keep up the good effort.",
    grades: [
      StudentCourseGrade(title: 'Electronics Devices and Circuit', code: 'EDC', credits: 4, finalGrade: 'B+', icon: Icons.memory),
      StudentCourseGrade(title: 'Engineering Mathematics-III', code: 'EM-III', credits: 3, finalGrade: 'A-', icon: Icons.calculate),
      StudentCourseGrade(title: 'Digital Electronics', code: 'DE', credits: 4, finalGrade: 'B', icon: Icons.developer_board),
      _esd,
      _pd,
      _uhv,
    ]
);

// --- 3. Grade Report for Average Student (e.g., Shivam) ---
// 🌟 FIX: GPA is now on a 10-point scale
const _report3 = GradeReport(
    termGpa: 7.8, // Changed from 3.15
    overallGrade: 'B',
    gpaMessage: "Good job! Let's aim higher next semester.",
    grades: [
      StudentCourseGrade(title: 'Electronics Devices and Circuit', code: 'EDC', credits: 4, finalGrade: 'B', icon: Icons.memory),
      StudentCourseGrade(title: 'Engineering Mathematics-III', code: 'EM-III', credits: 3, finalGrade: 'B', icon: Icons.calculate),
      StudentCourseGrade(title: 'Digital Electronics', code: 'DE', credits: 4, finalGrade: 'C+', icon: Icons.developer_board),
      _esd,
      _pd,
      StudentCourseGrade(title: 'Universal Human Value', code: 'UHV-1', credits: 3, finalGrade: 'A-', icon: Icons.public),
    ]
);

// --- Database Map (Links username to a Grade Report) ---
// (This part remains the same)
final Map<String, GradeReport> gradeDatabase = {
  'EC2240': _report1,
  'EC2221': _report2,
  'EC2223': _report3,

  // Assign the rest to one of the reports for demo purposes
  'EC2222': _report1,
  'EC2224': _report2,
  'EC2225': _report3,
  'EC2226': _report1,
  'EC2227': _report2,
  'EC2228': _report3,
  'EC2229': _report1,
  'EC2230': _report2,
  'EC2231': _report3,
  'EC2232': _report1,
  'EC2233': _report2,
  'EC2234': _report3,
  'EC2235': _report1,
  'EC2236': _report2,
  'EC2237': _report3,
  'EC2238': _report1,
  'EC2239': _report2,
};