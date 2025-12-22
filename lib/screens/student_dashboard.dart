import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/timetable_entry.dart';
import '../models/student_data.dart';
import '../models/grade_report.dart';
import '../utils/constants.dart';
import 'grades_screen.dart';
import 'due_work_screen.dart';
import 'student_notices_screen.dart';

class StudentDashboard extends StatelessWidget {
  final User user;
  final StudentData studentData;
  final GradeReport gradeReport;

  const StudentDashboard({
    super.key,
    required this.user,
    required this.studentData,
    required this.gradeReport,
  });

  // --- Navigation Actions ---

  void navigateToGrades(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradesScreen(gradeReport: gradeReport),
      ),
    );
  }

  void navigateToDueWork(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DueWorkScreen()),
    );
  }

  void navigateToRegister(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Navigating to Registration...'))
    );
  }

  // 🌟 FIX: Removed the '...' from (BuildContext... context)
  void navigateToNotices(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StudentNoticesScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCardColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome back, ${user.name.split(' ')[0]}!',
          style: TextStyle(
            color: onCardColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: onCardColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navigating to Settings Tab...'))
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (studentData.hasFeeAlert) _buildAlertBanner(context),
            const SizedBox(height: 20),
            _buildNextClassCard(context, studentData.nextClass),
            const SizedBox(height: 20),
            _buildAcademicProgressText(context, studentData),
            const SizedBox(height: 10),
            _buildAttendanceGpaGrid(context, studentData),
            const SizedBox(height: 20),
            Text('Quick Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onCardColor)),
            const SizedBox(height: 12),
            _buildQuickLinksGrid(context),
            const SizedBox(height: 20),
            Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onCardColor)),
            const SizedBox(height: 12),
            _buildRecentActivity(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS (All inside the Class) ---

  Widget _buildAlertBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Outstanding Fees',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your tuition fee payment of \$1,250 is overdue. Please pay now to avoid late charges.',
                  style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextClassCard(BuildContext context, TimetableEntry entry) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Next Class', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('In 15 min', style: TextStyle(color: Colors.orange.shade800, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.assignment_ind, color: primaryColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.course, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(height: 4),
                      Text('${entry.startTime} - ${entry.endTime} • ${entry.location}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicProgressText(BuildContext context, StudentData data) {
    double progress = data.creditsCompleted / data.totalCredits;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          minHeight: 5,
          borderRadius: BorderRadius.circular(5),
        ),
        const SizedBox(height: 4),
        Text(
          '${data.creditsCompleted} of ${data.totalCredits} credits completed towards graduation.',
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildAttendanceGpaGrid(BuildContext context, StudentData data) {
    final cardColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        // Attendance Card
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            color: cardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Overall Attendance', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 8),
                  Text(
                      '${(data.attendancePercentage * 100).toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // GPA Trend Card
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            color: cardColor,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GPA Trend', style: TextStyle(fontSize: 14, color: Colors.black54)),
                      Icon(Icons.show_chart, color: primaryColor, size: 20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: data.currentGpa / 10.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Current: ${data.currentGpa.toStringAsFixed(1)} GPA', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickLinksGrid(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.25,
      children: [
        _buildLinkCard(
            Icons.app_registration,
            'Register for Next Semester',
            context,
            onTap: () => navigateToRegister(context)
        ),
        _buildLinkCard(
            Icons.school,
            'View Grades',
            context,
            onTap: () => navigateToGrades(context)
        ),
        Card(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => navigateToDueWork(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      const Text('Due This Week', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Expanded(child: Text('EDC Lab: Practical 2 - Due Fri', style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const Expanded(child: Text('DE Quiz: Chapter 3 - Due Sun', style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
        ),
        Card(
          color: cardColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => navigateToNotices(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.campaign, color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          const Text('Notices', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Latest: Library closure for maintenance.', style: TextStyle(fontSize: 12), maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkCard(IconData icon, String label, BuildContext context, {VoidCallback? onTap}) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.star, color: Colors.green.shade600),
            title: const Text('New Grade Posted', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('You got an A in Digital Electronics.'),
            onTap: () {},
          ),
          const Divider(height: 0),
          ListTile(
            leading: Icon(Icons.menu_book, color: Colors.brown.shade600),
            title: const Text('Library Book Due', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('\'The Design of Everyday Things\' is due tomorrow.'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}