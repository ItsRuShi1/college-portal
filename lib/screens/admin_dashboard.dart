import 'package:flutter/material.dart';
import '../models/user.dart';
import 'manage_students_screen.dart'; // Import student management
import 'manage_teachers_screen.dart'; // Import teacher management
import 'manage_notices_screen.dart'; // Import notice management
import 'system_reports_screen.dart'; // Import reports screen

class AdminDashboard extends StatelessWidget {
  final User user;
  const AdminDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onCardColor = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            color: onCardColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: onCardColor),
            onPressed: () {
              // Handle notification tap
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. WELCOME TEXT
            Text(
              'Welcome, ${user.name}!',
              style: TextStyle(
                color: onCardColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // 2. STATS GRID
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(theme, 'Total Students', '1,250', Colors.blue),
                _buildStatCard(theme, 'Total Teachers', '150', Colors.green),
                _buildStatCard(theme, 'Total Notices', '88', Colors.orange),
                _buildStatCard(theme, 'System Alerts', '3', Colors.red),
              ],
            ),
            const SizedBox(height: 30),

            // 3. USER MANAGEMENT
            _buildSectionTitle('User Management', onCardColor),
            _buildManagementCard(
              context,
              children: [
                _buildManagementTile(
                  context,
                  icon: Icons.person_add_alt_1,
                  title: 'Add/Remove Student',
                  onTap: () {
                    // Navigate to the Manage Students screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageStudentsScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildManagementTile(
                  context,
                  icon: Icons.group_add,
                  title: 'Add/Remove Teacher',
                  onTap: () {
                    // Navigate to the Manage Teachers screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageTeachersScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 4. QUICK ACTIONS
            _buildSectionTitle('Quick Actions', onCardColor),
            _buildManagementCard(
              context,
              children: [
                _buildManagementTile(
                  context,
                  icon: Icons.campaign,
                  title: 'Manage Notices',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ManageNoticesScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildManagementTile(
                  context,
                  icon: Icons.analytics,
                  title: 'View System Reports',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SystemReportsScreen()),
                    );
                  },
                ),
              ],
            ),
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
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String label, String value, Color accentColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildManagementTile(BuildContext context, {required IconData icon, required String title, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        child: Icon(icon, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Colors.black54),
      onTap: onTap,
    );
  }
}