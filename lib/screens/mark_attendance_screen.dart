import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_button.dart';

// --- Models ---
enum AttendanceStatus { present, absent }

class StudentRoster {
  final String name;
  final String id;
  AttendanceStatus status;

  StudentRoster({
    required this.name,
    required this.id,
    this.status = AttendanceStatus.present,
  });
}

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  // --- Filter State ---
  String selectedBranch = 'Electronics';
  String selectedSection = 'Section B';
  DateTime selectedDate = DateTime.now();

  final List<String> branchOptions = ['Computer Science', 'Electronics', 'Mechanical'];
  final List<String> sectionOptions = ['Section A', 'Section B', 'Section C'];

  // --- Mock Data Synchronized with Fake User IDs ---
  List<StudentRoster> students = [
    StudentRoster(name: 'Jordan A. Smith', id: 'EC2221'),
    StudentRoster(name: 'Maya R. Patel', id: 'EC2222'),
    StudentRoster(name: 'Liam O. Bennett', id: 'EC2223', status: AttendanceStatus.absent),
    StudentRoster(name: 'Sophia L. Chen', id: 'EC2224'),
    StudentRoster(name: 'Ethan M. Rodriguez', id: 'EC2225'),
    StudentRoster(name: 'Chloe J. Williams', id: 'EC2226'),
    StudentRoster(name: 'Noah K. Tanaka', id: 'EC2227'),
    StudentRoster(name: 'Ava S. Gupta', id: 'EC2228'),
    StudentRoster(name: 'Lucas T. Müller', id: 'EC2229'),
    StudentRoster(name: 'Isabella F. Rossi', id: 'EC2230'),
    StudentRoster(name: 'Mason D. Wright', id: 'EC2231'),
    StudentRoster(name: 'Mia E. Kowalski', id: 'EC2232'),
    StudentRoster(name: 'Aiden B. Silva', id: 'EC2233'),
    StudentRoster(name: 'Emma V. Dubois', id: 'EC2234'),
    StudentRoster(name: 'James H. Kim', id: 'EC2235'),
    StudentRoster(name: 'Olivia G. Martinez', id: 'EC2236'),
    StudentRoster(name: 'Benjamin C. Lee', id: 'EC2237'),
    StudentRoster(name: 'Amara N. Okafor', id: 'EC2238'),
    StudentRoster(name: 'Samuel J. Thompson', id: 'EC2239'),
    StudentRoster(name: 'Zoe R. Jensen', id: 'EC2240'),
  ];

  void _selectAll() => setState(() => {for (var s in students) s.status = AttendanceStatus.present});
  void _deselectAll() => setState(() => {for (var s in students) s.status = AttendanceStatus.absent});

  void _performSave() {
    int present = students.where((s) => s.status == AttendanceStatus.present).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance Saved: $present Present, ${students.length - present} Absent'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  void _saveAttendance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Attendance?'),
        content: Text('Confirming attendance for ${DateFormat('yMMMd').format(selectedDate)} for $selectedBranch - $selectedSection.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Review')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); _performSave(); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade800),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Class Register', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeaderFilters(context),
          _buildSelectionToggles(theme),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) => _buildStudentTile(context, students[index]),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildHeaderFilters(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo.shade800,
      child: Row(
        children: [
          _filterDropdown(selectedBranch, branchOptions, (val) => setState(() => selectedBranch = val!)),
          const SizedBox(width: 8),
          _filterDropdown(selectedSection, sectionOptions, (val) => setState(() => selectedSection = val!)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () => _showDatePicker(context),
          )
        ],
      ),
    );
  }

  Widget _filterDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Colors.indigo.shade700,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          iconEnabledColor: Colors.white,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSelectionToggles(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text("Attendance Roster", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(onPressed: _selectAll, child: const Text("All Present")),
          TextButton(onPressed: _deselectAll, child: const Text("All Absent", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildStudentTile(BuildContext context, StudentRoster student) {
    bool isPresent = student.status == AttendanceStatus.present;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(student.id),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _attendanceButton('P', Colors.green, isPresent, () => setState(() => student.status = AttendanceStatus.present)),
            const SizedBox(width: 12),
            _attendanceButton('A', Colors.red, !isPresent, () => setState(() => student.status = AttendanceStatus.absent)),
          ],
        ),
      ),
    );
  }

  Widget _attendanceButton(String label, Color color, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isActive ? Colors.white : color, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: CustomButton(
        label: 'Submit Register',
        onPressed: _saveAttendance,
        color: Colors.indigo.shade800,
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }
}