import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Supporting Model (Normally in models/student_attendance_summary.dart) ---
class StudentAttendanceSummary {
  final String name;
  final String id;
  final double percentage;
  final int presentCount;
  final int absentCount;
  final String? avatarUrl;

  const StudentAttendanceSummary({
    required this.name,
    required this.id,
    required this.percentage,
    required this.presentCount,
    required this.absentCount,
    this.avatarUrl,
  });
}

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  // --- State Variables ---
  String _selectedCourse = 'Digital Electronics';
  bool _isAscending = true;

  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  final List<String> _courses = ['Digital Electronics', 'Circuit Theory', 'Advanced Math'];

  late List<StudentAttendanceSummary> _roster;

  @override
  void initState() {
    super.initState();
    // Synchronized Fake Data
    _roster = [
      const StudentAttendanceSummary(name: 'Jordan A. Smith', id: 'EC2221', percentage: 96.0, presentCount: 24, absentCount: 1),
      const StudentAttendanceSummary(name: 'Maya R. Patel', id: 'EC2222', percentage: 88.0, presentCount: 22, absentCount: 3),
      const StudentAttendanceSummary(name: 'Liam O. Bennett', id: 'EC2223', percentage: 68.0, presentCount: 17, absentCount: 8),
      const StudentAttendanceSummary(name: 'Sophia L. Chen', id: 'EC2224', percentage: 100.0, presentCount: 25, absentCount: 0),
      const StudentAttendanceSummary(name: 'Ethan M. Rodriguez', id: 'EC2225', percentage: 82.0, presentCount: 20, absentCount: 5),
      const StudentAttendanceSummary(name: 'Chloe J. Williams', id: 'EC2226', percentage: 94.0, presentCount: 23, absentCount: 2),
      const StudentAttendanceSummary(name: 'Noah K. Tanaka', id: 'EC2227', percentage: 65.0, presentCount: 16, absentCount: 9),
      const StudentAttendanceSummary(name: 'Ava S. Gupta', id: 'EC2228', percentage: 80.0, presentCount: 20, absentCount: 5),
      const StudentAttendanceSummary(name: 'Lucas T. Müller', id: 'EC2229', percentage: 96.0, presentCount: 24, absentCount: 1),
      const StudentAttendanceSummary(name: 'Isabella F. Rossi', id: 'EC2230', percentage: 72.0, presentCount: 18, absentCount: 7),
      const StudentAttendanceSummary(name: 'Mason D. Wright', id: 'EC2231', percentage: 92.0, presentCount: 23, absentCount: 2),
      const StudentAttendanceSummary(name: 'Mia E. Kowalski', id: 'EC2232', percentage: 98.0, presentCount: 24, absentCount: 1),
      const StudentAttendanceSummary(name: 'Aiden B. Silva', id: 'EC2233', percentage: 85.0, presentCount: 21, absentCount: 4),
      const StudentAttendanceSummary(name: 'Emma V. Dubois', id: 'EC2234', percentage: 74.0, presentCount: 18, absentCount: 7),
      const StudentAttendanceSummary(name: 'James H. Kim', id: 'EC2235', percentage: 96.0, presentCount: 24, absentCount: 1),
      const StudentAttendanceSummary(name: 'Olivia G. Martinez', id: 'EC2236', percentage: 88.0, presentCount: 22, absentCount: 3),
      const StudentAttendanceSummary(name: 'Benjamin C. Lee', id: 'EC2237', percentage: 70.0, presentCount: 17, absentCount: 8),
      const StudentAttendanceSummary(name: 'Amara N. Okafor', id: 'EC2238', percentage: 92.0, presentCount: 23, absentCount: 2),
      const StudentAttendanceSummary(name: 'Samuel J. Thompson', id: 'EC2239', percentage: 84.0, presentCount: 21, absentCount: 4),
      const StudentAttendanceSummary(name: 'Zoe R. Jensen', id: 'EC2240', percentage: 62.0, presentCount: 15, absentCount: 10),
    ];
    _sortRoster();
  }

  void _sortRoster() {
    setState(() {
      _roster.sort((a, b) => _isAscending
          ? a.percentage.compareTo(b.percentage)
          : b.percentage.compareTo(a.percentage));
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) setState(() => _selectedDateRange = picked);
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 90) return Colors.green.shade600;
    if (percentage >= 75) return Colors.orange.shade800;
    return Colors.red.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Attendance Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isAscending ? Icons.sort_rounded : Icons.filter_list_rounded),
            onPressed: () {
              _isAscending = !_isAscending;
              _sortRoster();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Export PDF'),
        icon: const Icon(Icons.picture_as_pdf),
        backgroundColor: Colors.indigo.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourseToggle(theme),
            const SizedBox(height: 20),
            _buildSectionTitle('Reporting Period', theme),
            _buildDateRangePicker(context, theme),
            const SizedBox(height: 20),
            _buildStatsGrid(theme),
            const SizedBox(height: 20),
            _buildOverallAttendanceCard(theme),
            const SizedBox(height: 24),
            _buildRosterSection(theme),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // --- Widget Build Methods ---

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
  }

  Widget _buildCourseToggle(ThemeData theme) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _courses.map((course) {
          final isSelected = _selectedCourse == course;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(course),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCourse = course),
              selectedColor: Colors.indigo.shade800,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDateRangePicker(BuildContext context, ThemeData theme) {
    String range = "${DateFormat('yMMMd').format(_selectedDateRange.start)} - ${DateFormat('yMMMd').format(_selectedDateRange.end)}";
    return Card(
      child: ListTile(
        leading: const Icon(Icons.date_range, color: Colors.indigo),
        title: Text(range, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        onTap: () => _selectDateRange(context),
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return Row(
      children: [
        _statBox('Total Present', '412', Colors.green),
        const SizedBox(width: 12),
        _statBox('Total Absent', '28', Colors.red),
      ],
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallAttendanceCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.indigo.shade700, Colors.indigo.shade500]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Class Average', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('Healthy', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Text('84.6%', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildRosterSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Student Roster (${_roster.length})', theme),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _roster.length,
          itemBuilder: (context, index) {
            final student = _roster[index];
            final color = _getPercentageColor(student.percentage);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Text(student.name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ),
                title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text(student.id, style: const TextStyle(fontSize: 12)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${student.percentage.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
                    Text('P:${student.presentCount} A:${student.absentCount}', style: const TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}