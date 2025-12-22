import 'package:flutter/material.dart';
import '../models/user.dart';
import 'login_screen.dart';
import '../main.dart'; // Ensure ClassroomApp.toggleTheme exists here
import 'custom_button.dart';

class TeacherProfileScreen extends StatefulWidget {
  final User user;

  const TeacherProfileScreen({super.key, required this.user});

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {

  void _handleLogout(BuildContext context) {
    // Standard practice: Show a confirmation before logging out
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to exit?'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Faculty Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          children: [
            // 1. HEADER
            _buildHeader(context),
            const SizedBox(height: 30),

            // 2. CONTACT INFORMATION (Updated with Fake Data)
            _buildInfoCard(
              title: 'Contact Details',
              children: [
                _buildContactTile(
                  context: context,
                  icon: Icons.email_outlined,
                  label: 'University Email',
                  value: 'm.thorne@university.edu',
                ),
                _buildContactTile(
                  context: context,
                  icon: Icons.phone_android,
                  label: 'Work Phone',
                  value: '+1 (555) 012-3456',
                ),
                _buildContactTile(
                  context: context,
                  icon: Icons.location_on_outlined,
                  label: 'Office Location',
                  value: 'Engineering Bldg, Room 402',
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 3. ACADEMIC STATS
            _buildInfoCard(
              title: 'Professional Summary',
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildAcademicStat(theme, 'Faculty ID', 'ETC-101'),
                    _buildAcademicStat(theme, 'Dept', 'Electronics'),
                    _buildAcademicStat(theme, 'Experience', '8 Years'),
                    _buildAcademicStat(theme, 'Publications', '14 Papers'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. SETTINGS
            _buildInfoCard(
              title: 'Preferences',
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: theme.colorScheme.primary),
                  title: const Text('Appearance', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  subtitle: Text(isDark ? 'Dark Mode Active' : 'Light Mode Active', style: const TextStyle(fontSize: 12)),
                  value: isDark,
                  onChanged: (value) => ClassroomApp.toggleTheme(context),
                  activeColor: theme.colorScheme.primary,
                ),
                _buildSettingsTile(context, Icons.lock_outline, 'Privacy & Security'),
                _buildSettingsTile(context, Icons.notifications_none, 'Notification Settings'),
              ],
            ),
            const SizedBox(height: 40),

            // 5. LOGOUT
            CustomButton(
              label: 'Sign Out',
              onPressed: () => _handleLogout(context),
              color: Colors.red.shade50,
              textColor: Colors.red.shade700,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.edit, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(widget.user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Senior Professor • Electronics', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildContactTile({required BuildContext context, required IconData icon, required String label, required String value, bool isLast = false}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        if (!isLast) Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Divider(color: Colors.grey.withOpacity(0.1))),
      ],
    );
  }

  Widget _buildAcademicStat(ThemeData theme, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {},
    );
  }
}