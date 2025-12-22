import 'package:flutter/material.dart';
import '../models/student_course_grade.dart';
import '../models/grade_report.dart';

class GradesScreen extends StatefulWidget {
  final GradeReport gradeReport;

  const GradesScreen({super.key, required this.gradeReport});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  String selectedSemester = 'Fall 2024';
  final List<String> semesters = ['Fall 2024', 'Spring 2024', 'Fall 2023', 'Spring 2023'];

  late GradeReport _displayReport;
  final double BREAKPOINT = 800.0; // Breakpoint for switching to desktop layout

  // Create mock reports for other semesters (reusing previous logic)
  static const GradeReport _spring2024Report = GradeReport(
      termGpa: 8.5,
      overallGrade: 'A-',
      gpaMessage: "Excellent work in the spring semester!",
      grades: [
        StudentCourseGrade(title: 'Data Structures', code: 'CS201', credits: 4, finalGrade: 'A', icon: Icons.data_usage),
        StudentCourseGrade(title: 'Physics II', code: 'PHY102', credits: 4, finalGrade: 'B+', icon: Icons.lightbulb),
        StudentCourseGrade(title: 'Calculus II', code: 'MATH102', credits: 3, finalGrade: 'A-', icon: Icons.calculate),
      ]
  );

  static const GradeReport _fall2023Report = GradeReport(
      termGpa: 7.8,
      overallGrade: 'B',
      gpaMessage: "A strong start to the year.",
      grades: [
        StudentCourseGrade(title: 'Intro to Programming', code: 'CS101', credits: 4, finalGrade: 'B+', icon: Icons.code),
        StudentCourseGrade(title: 'Physics I', code: 'PHY101', credits: 4, finalGrade: 'B', icon: Icons.lightbulb_outline),
        StudentCourseGrade(title: 'Calculus I', code: 'MATH101', credits: 3, finalGrade: 'B-', icon: Icons.calculate_outlined),
      ]
  );

  @override
  void initState() {
    super.initState();
    _displayReport = widget.gradeReport;
  }

  // --- Widget Builders ---

  // Main Builder that switches between Mobile/Desktop layouts
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('My Grades', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > BREAKPOINT) {
            return _buildDesktopLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
      floatingActionButton: Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Downloading transcript...')),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.download, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Layout for wide screens (Desktop/Tablet Landscape)
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSemesterTabs(), // Tabs remain horizontal across the top
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: GPA Summary Card (Fixed Width)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _buildGpaSummaryCard(),
                  ),
                ),
                // Column 2: Course Grades List (Expanded)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                          child: Text(
                            'Course Grades',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        ..._displayReport.grades.map(_buildGradeListItem).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Layout for mobile screens (Stacked)
  Widget _buildMobileLayout(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSemesterTabs(),
              _buildGpaSummaryCard(),

              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 10.0),
                child: Text(
                  'Course Grades',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: _displayReport.grades.map(_buildGradeListItem).toList(),
                ),
              ),
              const SizedBox(height: 100), // Space for the FAB
            ],
          ),
        ),
      ],
    );
  }

  // --- Core Components ---

  Widget _buildSemesterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
      child: Row(
        children: semesters.map((semester) {
          final isSelected = semester == selectedSemester;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSemester = semester;
                  if (semester == 'Spring 2024') {
                    _displayReport = _spring2024Report;
                  } else if (semester == 'Fall 2023') {
                    _displayReport = _fall2023Report;
                  } else {
                    _displayReport = widget.gradeReport;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface.withAlpha(204), // 204 is 0.8 * 255
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
                ),
                child: Text(
                  semester,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGpaSummaryCard() {
    final report = _displayReport;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Term GPA', style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(
                  report.termGpa.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  report.gpaMessage,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          // GPA Circle
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: report.termGpa / 10.0,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  strokeWidth: 8,
                ),
              ),
              Text(
                report.overallGrade,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGradeListItem(StudentCourseGrade grade) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          grade.icon,
          size: 30,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          grade.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          '${grade.code} | ${grade.credits} Credits',
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              grade.finalGrade,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}