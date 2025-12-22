import 'student_course_grade.dart';

class GradeReport {
  final double termGpa;
  final String overallGrade; // e.g., 'A' or 'B+'
  final String gpaMessage;
  final List<StudentCourseGrade> grades;

  const GradeReport({
    required this.termGpa,
    required this.overallGrade,
    required this.gpaMessage,
    required this.grades,
  });
}