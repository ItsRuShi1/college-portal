// lib/screens/system_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity_log.dart';

class SystemReportsScreen extends StatefulWidget {
  const SystemReportsScreen({super.key});

  @override
  State<SystemReportsScreen> createState() => _SystemReportsScreenState();
}

class _SystemReportsScreenState extends State<SystemReportsScreen> {
  int _selectedTab = 0;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  // --- Mock Data Synchronized with Global Fake Identities ---
  final List<ActivityLog> _logs = [
    ActivityLog(user: 'Admin', action: 'Modified System Permissions', timestamp: DateTime(2025, 12, 22, 14, 20)),
    ActivityLog(user: 'Prof. Marcus Thorne', action: 'Published Final Timetable', timestamp: DateTime(2025, 12, 22, 11, 05)),
    ActivityLog(user: 'Jordan A. Smith', action: 'Reset Account Password', timestamp: DateTime(2025, 12, 21, 16, 45)),
    ActivityLog(user: 'Dr. Elena Vance', action: 'Uploaded Attendance CSV', timestamp: DateTime(2025, 12, 21, 09, 30)),
    ActivityLog(user: 'Maya R. Patel', action: 'Submitted Lab Assignment', timestamp: DateTime(2025, 12, 20, 22, 15)),
    ActivityLog(user: 'Admin', action: 'Archived Previous Semester Data', timestamp: DateTime(2025, 12, 20, 10, 00)),
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) _startDate = picked; else _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Admin Audit Logs', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating CSV Report...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTabSelector(context),
            const SizedBox(height: 20),
            _buildDateRangeHeader(context),
            const SizedBox(height: 20),
            _buildStatsGrid(context),
            const SizedBox(height: 20),
            _buildActivityLog(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SegmentedButton<int>(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Colors.indigo.shade800,
          selectedForegroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          side: BorderSide.none,
        ),
        segments: const [
          ButtonSegment(value: 0, label: Text('Activities'), icon: Icon(Icons.history)),
          ButtonSegment(value: 1, label: Text('Logins'), icon: Icon(Icons.login)),
          ButtonSegment(value: 2, label: Text('Usage'), icon: Icon(Icons.data_usage)),
        ],
        selected: {_selectedTab},
        onSelectionChanged: (val) => setState(() => _selectedTab = val.first),
      ),
    );
  }

  Widget _buildDateRangeHeader(BuildContext context) {
    return Row(
      children: [
        _dateButton("From", _startDate, () => _selectDate(context, true)),
        const SizedBox(width: 12),
        _dateButton("To", _endDate, () => _selectDate(context, false)),
      ],
    );
  }

  Widget _dateButton(String label, DateTime date, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(DateFormat('MMM dd, yyyy').format(date), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        _reportStatCard('System Events', '4,821', '+12%', Colors.green),
        const SizedBox(width: 12),
        _reportStatCard('Active Sessions', '89', 'Stable', Colors.blue),
      ],
    );
  }

  Widget _reportStatCard(String label, String value, String trend, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(trend, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLog(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Detailed Audit Trail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _logs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final log = _logs[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: log.user == 'Admin' ? Colors.red.shade50 : Colors.indigo.shade50,
                  child: Icon(
                    log.user == 'Admin' ? Icons.security : Icons.person_outline,
                    color: log.user == 'Admin' ? Colors.red : Colors.indigo,
                    size: 20,
                  ),
                ),
                title: Text(log.action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text('By ${log.user}', style: const TextStyle(fontSize: 11)),
                trailing: Text(
                  DateFormat('HH:mm\nMMM dd').format(log.timestamp),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}