// Represents the student's card in the
import 'grade_item.dart';
class StudentGradeSummary {
  final String name;
  final String id;
  final String? avatarUrl;
  final String overallGrade;
  final List<GradeItem> gradeItems; // A list of their individual grades

  StudentGradeSummary({
    required this.name,
    required this.id,
    this.avatarUrl,
    required this.overallGrade,
    required this.gradeItems,
  });
}