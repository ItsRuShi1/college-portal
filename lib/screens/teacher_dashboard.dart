import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/constants.dart';
// 1. Import the file
import 'mark_attendance_screen.dart';
import 'attendance_report_screen.dart';
import 'teacher_gradebook_screen.dart';
import 'post_notice_form_screen.dart';
import 'package:intl/intl.dart';

// Course Model
class Course {
  final String title;
  final String code;
  final IconData icon;
  final Color color;

  const Course({
    required this.title,
    required this.code,
    required this.icon,
    required this.color,
  });
}

class TeacherDashboard extends StatelessWidget {
  final User user;
  const TeacherDashboard({super.key, required this.user});

  // --- Constants ---
  final int TITLE_CHAR_LIMIT = 20;

  // --- Mock Data ---
  final List<Course> courses = const [
    Course(title: 'Electronics Devices and Circuit', code: 'EDC', icon: Icons.memory, color: Color(0xFF4CAF50)),
    Course(title: 'Digital Electronics', code: 'DE', icon: Icons.developer_board, color: Color(0xFF2196F3)),
    Course(title: 'Engineering Mathematics-III', code: 'EM-III', icon: Icons.calculate, color: Color(0xFFF44336)),
    Course(title: 'Employability and skill Development', code: 'E&SD', icon: Icons.work, color: Color(0xFFFF9800)),
    Course(title: 'Personality Development', code: 'PD', icon: Icons.person, color: Color(0xFF9C27B0)),
  ];

  final Map<String, double> mockWeeklyAttendance = const {
    'Mon': 0.85, 'Tue': 0.90, 'Wed': 0.88, 'Thu': 0.95, 'Fri': 0.92
  };
  final String activeCourseCode = 'MATH-501';

  String _getDisplayTitle(String title, String code) {
    return title.length > TITLE_CHAR_LIMIT ? code : title;
  }

  // --- Dialog Method ---
  Future<void> _showPostNoticeDialog(BuildContext context) async {
    String? title = '';
    String? body = '';
    String? category = 'General';
    final List<String> categories = ['Academics', 'Events', 'Campus', 'General'];

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Post Quick Notice'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                      items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (v) => setDialogState(() => category = v),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Title', border: OutlineInputBorder()),
                      onChanged: (v) => title = v,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: 'Content...', border: OutlineInputBorder()),
                      onChanged: (v) => body = v,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(dialogContext)),
            ElevatedButton(
              child: const Text('Post'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice Posted!')));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCardColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(backgroundImage: AssetImage('assets/profile_avatar.png')),
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(color: onCardColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(context, user),
            const SizedBox(height: 24),
            _buildSectionTitle('Courses Taught', onCardColor),
            _buildCourseSelector(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Quick Actions', onCardColor),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Recent Activity', onCardColor),
            _buildRecentActivity(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Performance Trend', onCardColor),
            _buildPerformanceTrend(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${user.name}!',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your overview for today.',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: courses.map((course) {
          final isSelected = course.code == activeCourseCode;
          final displayTitle = _getDisplayTitle(course.title, course.code);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary) : Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                displayTitle,
                style: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.25,
      children: [
        // Mark Attendance Button
        _buildActionCard(context, Icons.check_circle, 'Mark Attendance', const Color(0xFF4CAF50), onTap: () {
          Navigator.push(
            context,
            // 🌟 FIX: Use MarkAttendanceScreen class name
            MaterialPageRoute(builder: (context) => const MarkAttendanceScreen()),
          );
        }),
        // View Report Button
        _buildActionCard(context, Icons.assessment, 'View Report', const Color(0xFF1E88E5), onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AttendanceReportScreen()),
          );
        }),
        // Post Notice Button
        _buildActionCard(context, Icons.send, 'Post Notice', const Color(0xFFFB8C00), onTap: () => _showPostNoticeDialog(context)),
        // View Grades Button
        _buildActionCard(context, Icons.bar_chart, 'View Grades', const Color(0xFFE53935), onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeacherGradebookScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String label, Color accentColor, {VoidCallback? onTap}) {
    final cardColor = Theme.of(context).colorScheme.surface;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: accentColor.withOpacity(0.5), width: 1),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      children: [
        _buildActivityTile(context, Icons.check_box_outline_blank, Colors.orange, 'New Submission: MATH-301', 'John Doe submitted \'Calculus Assignment\'.'),
        const SizedBox(height: 12),
        _buildActivityTile(context, Icons.campaign, Colors.blue, 'Notice Posted', 'You posted \'Mid-term Exam Schedule\'.'),
      ],
    );
  }

  Widget _buildActivityTile(BuildContext context, IconData icon, Color iconColor, String title, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.25),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Widget _buildPerformanceTrend(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).colorScheme.surface;
    const double maxHeight = 150.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overall attendance across all classes', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 20),
            SizedBox(
              height: maxHeight + 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: mockWeeklyAttendance.entries.map((entry) {
                  final day = entry.key;
                  final attendance = entry.value;
                  final barHeight = attendance * maxHeight;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${(attendance * 100).toInt()}%', style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Container(
                        width: 20, height: barHeight,
                        decoration: BoxDecoration(color: primaryColor.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                      ),
                      const SizedBox(height: 8),
                      Text(day, style: TextStyle(color: Colors.grey[600])),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}