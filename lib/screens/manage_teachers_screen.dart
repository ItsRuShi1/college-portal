// lib/screens/manage_teachers_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'custom_button.dart'; // Ensure this matches your project structure

class TeacherInfo {
  final String name;
  final String id;
  final String department;
  TeacherInfo({required this.name, required this.id, required this.department});
}

class ManageTeachersScreen extends StatefulWidget {
  const ManageTeachersScreen({super.key});

  @override
  State<ManageTeachersScreen> createState() => _ManageTeachersScreenState();
}

class _ManageTeachersScreenState extends State<ManageTeachersScreen> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  String? _selectedDept;
  String? _selectedDesignation;
  DateTime? _joiningDate;

  final List<String> _deptOptions = ['Electronics', 'Computer Science', 'Mathematics', 'Humanities'];
  final List<String> _designationOptions = ['Professor', 'Asst. Professor', 'Lecturer', 'Lab Instructor'];

  // --- Mock Data Synchronized with previous files ---
  final List<TeacherInfo> _allTeachers = [
    TeacherInfo(name: 'Prof. Marcus Thorne', id: 'ETC101', department: 'Electronics'),
    TeacherInfo(name: 'Dr. Elena Vance', id: 'ETC102', department: 'Electronics'),
    TeacherInfo(name: 'Dr. Sarah Jenkins', id: 'MATH303', department: 'Mathematics'),
    TeacherInfo(name: 'Dr. Robert Miller', id: 'HUM401', department: 'Humanities'),
    TeacherInfo(name: 'Prof. Chloe Williams', id: 'SD105', department: 'Computer Science'),
  ];

  List<TeacherInfo> _filteredTeachers = [];

  @override
  void initState() {
    super.initState();
    _filteredTeachers = _allTeachers;
    _searchCtrl.addListener(_performSearch);
  }

  void _performSearch() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredTeachers = _allTeachers.where((teacher) {
        return teacher.name.toLowerCase().contains(query) ||
            teacher.id.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _dateCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _joiningDate = picked;
        _dateCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Manage Faculty', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Add New Teacher', Icons.person_add_alt_1),
            const SizedBox(height: 16),

            _buildFormCard(theme),

            const SizedBox(height: 32),
            _buildSectionHeader('Faculty Directory', Icons.badge),
            const SizedBox(height: 16),

            TextField(
              controller: _searchCtrl,
              decoration: _buildInputDecoration(
                hint: 'Search by name or ID...',
                suffixIcon: Icons.search,
              ),
            ),
            const SizedBox(height: 16),

            // Teacher List
            ..._filteredTeachers.map((teacher) => _buildTeacherTile(context, teacher)).toList(),
            if (_filteredTeachers.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('No faculty members found.'),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo.shade800),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFormCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          TextField(controller: _nameCtrl, decoration: _buildInputDecoration(hint: 'Full Name')),
          const SizedBox(height: 12),
          TextField(controller: _idCtrl, decoration: _buildInputDecoration(hint: 'Faculty ID')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: _buildInputDecoration(hint: 'Department'),
            items: _deptOptions.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (val) => _selectedDept = val,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dateCtrl,
            readOnly: true,
            decoration: _buildInputDecoration(hint: 'Joining Date', suffixIcon: Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Register Faculty', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hint, IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    );
  }

  Widget _buildTeacherTile(BuildContext context, TeacherInfo teacher) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade50,
          child: Text(teacher.name[0], style: TextStyle(color: Colors.indigo.shade800, fontWeight: FontWeight.bold)),
        ),
        title: Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${teacher.id} • ${teacher.department}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () {},
        ),
      ),
    );
  }
}