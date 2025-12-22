import 'package:flutter/material.dart';
import '../models/user.dart';
import 'login_screen.dart';
import '../main.dart';
import 'custom_button.dart';

// --- MOCK DATA (Synchronized with Global Fake Identity) ---
String _currentBio = 'Electronics & Communication student passionate about IoT and Flutter development. Currently working on a project involving smart sensor networks.';
List<String> _currentSkills = ['Dart & Flutter', 'Arduino', 'C++', 'Circuit Design', 'Verilog'];
String _currentPhone = '+1 (555) 019-8822';
String _currentAddress = 'Engineering Block A, University Residential Complex';

class StudentProfileScreen extends StatefulWidget {
  final User user;

  const StudentProfileScreen({super.key, required this.user});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {

  // --- LOGIC ---

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to end your session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditModal({required String title, required Widget content, required VoidCallback onSave}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 20, left: 20, right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 20),
            CustomButton(
                label: 'Update Profile',
                onPressed: () {
                  onSave();
                  Navigator.pop(context);
                }
            ),
          ],
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            _buildProfileHeader(theme),
            const SizedBox(height: 24),

            _buildAboutCard(theme),
            const SizedBox(height: 16),

            _buildSkillsCard(theme),
            const SizedBox(height: 16),

            _buildAcademicCard(theme),
            const SizedBox(height: 16),

            _buildContactCard(theme),
            const SizedBox(height: 16),

            _buildSettingsCard(theme, isDark),
            const SizedBox(height: 32),

            CustomButton(
              label: 'Logout',
              onPressed: () => _handleLogout(context),
              color: Colors.red.shade50,
              textColor: Colors.red.shade700,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Icon(Icons.person, size: 50, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 12),
        Text(widget.user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('ID: ${widget.user.username} • ${widget.user.role.toUpperCase()}',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildAboutCard(ThemeData theme) {
    final controller = TextEditingController(text: _currentBio);
    return _buildCardTemplate(
      title: 'About Me',
      onEdit: () => _showEditModal(
        title: 'Edit Bio',
        content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder())),
        onSave: () => setState(() => _currentBio = controller.text),
      ),
      child: Text(_currentBio, style: const TextStyle(fontSize: 14, height: 1.4)),
    );
  }

  Widget _buildSkillsCard(ThemeData theme) {
    return _buildCardTemplate(
      title: 'Skills & Interests',
      child: Wrap(
        spacing: 8,
        children: _currentSkills.map((s) => Chip(
          label: Text(s, style: const TextStyle(fontSize: 12)),
          backgroundColor: theme.colorScheme.primary.withOpacity(0.05),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        )).toList(),
      ),
    );
  }

  Widget _buildAcademicCard(ThemeData theme) {
    return _buildCardTemplate(
      title: 'Academic Record',
      child: Column(
        children: [
          _rowInfo('Department', 'Electronics & Communication'),
          _rowInfo('Batch', '2022 - 2026'),
          _rowInfo('Current GPA', '8.9 / 10.0'),
          _rowInfo('Status', 'Regular', isLast: true),
        ],
      ),
    );
  }

  Widget _buildContactCard(ThemeData theme) {
    return _buildCardTemplate(
      title: 'Contact Information',
      child: Column(
        children: [
          _rowInfo('Email', '${widget.user.username.toLowerCase()}@university.edu'),
          _rowInfo('Phone', _currentPhone),
          _rowInfo('Address', _currentAddress, isLast: true),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(ThemeData theme, bool isDark) {
    return _buildCardTemplate(
      title: 'App Settings',
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Dark Mode', style: TextStyle(fontSize: 14)),
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 20),
            value: isDark,
            onChanged: (val) => ClassroomApp.toggleTheme(context),
          ),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.lock_outline, size: 20),
            title: Text('Change Password', style: TextStyle(fontSize: 14)),
            trailing: Icon(Icons.chevron_right, size: 16),
          ),
        ],
      ),
    );
  }

  // --- REUSABLE TEMPLATES ---

  Widget _buildCardTemplate({required String title, required Widget child, VoidCallback? onEdit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (onEdit != null) IconButton(icon: const Icon(Icons.edit, size: 16), onPressed: onEdit),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _rowInfo(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}