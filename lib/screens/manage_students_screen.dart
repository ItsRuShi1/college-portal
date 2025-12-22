import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Run 'flutter pub add intl'
import 'custom_button.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  // State for the tabs (0 = Add, 1 = Remove)
  int _selectedTab = 0;

  // Form controllers
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _yearController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedDepartment;
  DateTime? _selectedEnrollmentDate;

  final List<String> _departmentOptions = ['Computer Science', 'Electronics', 'Mechanical', 'Civil'];

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _yearController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- Date Picker Logic ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEnrollmentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedEnrollmentDate) {
      setState(() {
        _selectedEnrollmentDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Manage Students', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Tab Selector ---
            _buildTabSelector(context),
            const SizedBox(height: 24),

            // --- Show content based on selected tab ---
            _selectedTab == 0
                ? _buildAddStudentForm(context)
                : _buildRemoveStudentView(context),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildTabSelector(BuildContext context) {
    // Using SegmentedButton for a modern tab look
    return Center(
      child: SegmentedButton<int>(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.black54,
          selectedBackgroundColor: Theme.of(context).colorScheme.primary,
          selectedForegroundColor: Colors.white,
        ),
        segments: const [
          ButtonSegment<int>(
            value: 0,
            label: Text('Add Student', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ButtonSegment<int>(
            value: 1,
            label: Text('Remove Student', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
        selected: {_selectedTab},
        onSelectionChanged: (Set<int> newSelection) {
          setState(() {
            _selectedTab = newSelection.first;
          });
        },
      ),
    );
  }

  Widget _buildAddStudentForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add a New Student',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // Full Name
        _buildFormLabel('Full Name'),
        TextField(
          controller: _nameController,
          decoration: _buildInputDecoration(hint: 'Enter student\'s full name'),
        ),
        const SizedBox(height: 16),

        // Student ID
        _buildFormLabel('Student ID'),
        TextField(
          controller: _idController,
          decoration: _buildInputDecoration(hint: 'Enter student ID'),
        ),
        const SizedBox(height: 16),

        // Department
        _buildFormLabel('Department'),
        DropdownButtonFormField<String>(
          value: _selectedDepartment,
          decoration: _buildInputDecoration(hint: 'Select Department'),
          items: _departmentOptions.map((String department) {
            return DropdownMenuItem<String>(
              value: department,
              child: Text(department),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDepartment = newValue;
            });
          },
        ),
        const SizedBox(height: 16),

        // Year/Semester
        _buildFormLabel('Year/Semester'),
        TextField(
          controller: _yearController,
          decoration: _buildInputDecoration(hint: 'e.g., 3rd Year'),
        ),
        const SizedBox(height: 16),

        // Enrollment Date
        _buildFormLabel('Enrollment Date'),
        TextField(
          controller: _dateController,
          readOnly: true,
          decoration: _buildInputDecoration(
            hint: 'mm/dd/yyyy',
            suffixIcon: Icons.calendar_month,
          ),
          onTap: () => _selectDate(context),
        ),
        const SizedBox(height: 30),

        // Add Student Button
        CustomButton(
          label: 'Add Student',
          onPressed: () {
            // Handle add student logic here
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adding student...')),
            );
          },
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildRemoveStudentView(BuildContext context) {
    // Placeholder for the "Remove Student" UI
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          'Student removal interface would go here, likely a searchable list.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  // Helper for form field labels
  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Helper for text field styling
  InputDecoration _buildInputDecoration({required String hint, IconData? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}