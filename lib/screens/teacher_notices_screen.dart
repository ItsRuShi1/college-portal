import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/admin_notice.dart';
import 'post_notice_form_screen.dart';

class TeacherNoticesScreen extends StatefulWidget {
  const TeacherNoticesScreen({super.key});

  @override
  State<TeacherNoticesScreen> createState() => _TeacherNoticesScreenState();
}

class _TeacherNoticesScreenState extends State<TeacherNoticesScreen> {
  // Mock data for the notices
  final List<AdminNotice> _notices = [
    AdminNotice(
      title: 'Mid-Term Exam Schedule Revision',
      body: 'Please note that the schedule for the upcoming mid-term examinations has been updated. All students and faculty are requested to refer to the new timetable available on the portal.',
      category: 'Academics',
      author: 'Admin',
      postDate: DateTime(2025, 10, 26),
    ),
    AdminNotice(
      title: 'Annual Sports Day Announcement',
      body: 'Get ready for the most awaited event of the year! The Annual Sports Day will be held on the 15th of November. Registrations are now open for all events.',
      category: 'Events',
      author: 'Admin',
      postDate: DateTime(2025, 10, 24),
    ),
    AdminNotice(
      title: 'Library Closure for Maintenance',
      body: 'The central library will be closed for annual maintenance from November 1st to November 5th. Please return all borrowed books by October 31st.',
      category: 'Campus',
      author: 'Admin',
      postDate: DateTime(2025, 10, 22),
    ),
  ];

  void _postNewNotice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PostNoticeFormScreen()),
    );
  }

  void _editNotice(AdminNotice notice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing ${notice.title}...')),
    );
  }

  void _deleteNotice(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deleting notice...')),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Notices', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.colorScheme.onBackground),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _postNewNotice(context),
        label: const Text('Post New Notice', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
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

            // Footer Row (Posted on, View Details, Edit/Delete)
            // 🌟 FIX: Constrain the "Posted On" text using Expanded 🌟
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // FIX: Constrain the text to the available width
                  child: Text(
                    'Posted on: $formattedDate by ${notice.author}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min, // Ensure action buttons take minimal space
                  children: [
                    TextButton(
                      onPressed: onEdit,
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 20, color: theme.colorScheme.primary),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.red.shade700),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}