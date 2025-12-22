import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Run 'flutter pub add intl'
import '../models/admin_notice.dart'; // Import the new model

class ManageNoticesScreen extends StatefulWidget {
  const ManageNoticesScreen({super.key});

  @override
  State<ManageNoticesScreen> createState() => _ManageNoticesScreenState();
}

class _ManageNoticesScreenState extends State<ManageNoticesScreen> {
  // Mock data for the notices
  final List<AdminNotice> _notices = [
    AdminNotice(
      title: 'Mid-Term Examination Schedule',
      body: 'The schedule for the upcoming mid-term examinations for all departments has been released.',
      category: 'Academics',
      author: 'Admin',
      postDate: DateTime(2025, 10, 26),
    ),
    AdminNotice(
      title: 'Annual Sports Day Announcement',
      body: 'Get ready for the most awaited event of the year! Registrations are now open for all students.',
      category: 'Events',
      author: 'Admin',
      postDate: DateTime(2025, 10, 24),
    ),
    AdminNotice(
      title: 'Library Closure Notice',
      body: 'The central library will be closed for maintenance this coming weekend. Please plan accordingly.',
      category: 'Campus',
      author: 'Admin',
      postDate: DateTime(2025, 10, 22),
    ),
  ];

  void _deleteNotice(int index) {
    // Show a confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this notice?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
            onPressed: () {
              setState(() {
                _notices.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _editNotice(AdminNotice notice) {
    // Placeholder for edit logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${notice.title}...')),
    );
  }

  void _postNewNotice() {
    // Placeholder for post logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening new notice form...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Manage Notices', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: false,
        backgroundColor: theme.colorScheme.primary, // Blue app bar
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _postNewNotice,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return _buildNoticeCard(context, notice, () => _editNotice(notice), () => _deleteNotice(index));
        },
      ),
    );
  }

  // Helper widget to build each notice card
  Widget _buildNoticeCard(BuildContext context, AdminNotice notice, VoidCallback onEdit, VoidCallback onDelete) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('MMM d, yyyy').format(notice.postDate);
    final categoryColor = notice.category == 'Academics' ? Colors.blue : (notice.category == 'Events' ? Colors.orange : Colors.green);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            Text(
              notice.category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
            const SizedBox(height: 8),

            // Notice Title
            Text(
              notice.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Notice Body
            Text(
              notice.body,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            // Footer (Posted on)
            Text(
              'Posted on: $formattedDate by ${notice.author}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const Divider(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                  onPressed: onEdit,
                  tooltip: 'Edit Notice',
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red.shade700),
                  onPressed: onDelete,
                  tooltip: 'Delete Notice',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}