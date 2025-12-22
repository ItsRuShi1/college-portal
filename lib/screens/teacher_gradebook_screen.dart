// lib/screens/teacher_gradebook_screen.dart
import 'package:flutter/material.dart';

// --- MODELS ---
class GradeItem {
  final String title;
  String grade;

  GradeItem({required this.title, required this.grade});
}

class StudentGradeSummary {
  final String name;
  final String id;
  String overallGrade;
  final List<GradeItem> gradeItems;

  StudentGradeSummary({
    required this.name,
    required this.id,
    required this.overallGrade,
    required this.gradeItems,
  });
}

class TeacherGradebookScreen extends StatefulWidget {
  const TeacherGradebookScreen({super.key});

  @override
  State<TeacherGradebookScreen> createState() => _TeacherGradebookScreenState();
}

class _TeacherGradebookScreenState extends State<TeacherGradebookScreen> {
  String _selectedCourse = 'Digital Electronics (DE)';
  final List<String> _courseOptions = [
    'Digital Electronics (DE)',
    'Circuit Theory (CT)',
    'Advanced Mathematics (AM-III)',
    'Embedded Systems (ES)',
  ];

  // --- MOCK DATA (Synchronized with Global Fake Identities) ---
  final List<StudentGradeSummary> _students = [
    StudentGradeSummary(
      name: 'Jordan A. Smith', id: 'EC2221', overallGrade: 'A',
      gradeItems: [GradeItem(title: 'Midterm', grade: '94'), GradeItem(title: 'Quiz 1', grade: 'A+')],
    ),
    StudentGradeSummary(
      name: 'Maya R. Patel', id: 'EC2222', overallGrade: 'B+',
      gradeItems: [GradeItem(title: 'Midterm', grade: '82'), GradeItem(title: 'Quiz 1', grade: 'B')],
    ),
    StudentGradeSummary(
      name: 'Liam O. Bennett', id: 'EC2223', overallGrade: 'C',
      gradeItems: [GradeItem(title: 'Midterm', grade: '65'), GradeItem(title: 'Quiz 1', grade: 'C-')],
    ),
    StudentGradeSummary(
      name: 'Sophia L. Chen', id: 'EC2224', overallGrade: 'A',
      gradeItems: [GradeItem(title: 'Midterm', grade: '98'), GradeItem(title: 'Quiz 1', grade: 'A')],
    ),
    StudentGradeSummary(
      name: 'Zoe R. Jensen', id: 'EC2240', overallGrade: 'D',
      gradeItems: [GradeItem(title: 'Midterm', grade: '55'), GradeItem(title: 'Quiz 1', grade: 'F')],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Sort students by grade (A to F)
    _students.sort((a, b) => a.overallGrade.compareTo(b.overallGrade));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Faculty Gradebook', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _students.length,
              itemBuilder: (context, index) => _buildStudentCard(_students[index], theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Active Course', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCourse,
              isExpanded: true,
              items: _courseOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCourse = val!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(StudentGradeSummary student, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(student.name[0], style: TextStyle(color: Colors.indigo.shade800, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(student.id, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                _gradeBadge(student.overallGrade),
                IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: student.gradeItems.map((item) => _itemTag(item)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradeBadge(String grade) {
    bool isLow = grade == 'D' || grade == 'F';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLow ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        grade,
        style: TextStyle(fontWeight: FontWeight.bold, color: isLow ? Colors.red : Colors.green),
      ),
    );
  }

  Widget _itemTag(GradeItem item) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
      child: Text('${item.title}: ${item.grade}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }
}