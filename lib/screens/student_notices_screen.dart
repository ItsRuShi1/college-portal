import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Run 'flutter pub add intl'
import '../models/admin_notice.dart'; // Import the model

class StudentNoticesScreen extends StatefulWidget {
  const StudentNoticesScreen({super.key});

  @override
  State<StudentNoticesScreen> createState() => _StudentNoticesScreenState();
}

class _StudentNoticesScreenState extends State<StudentNoticesScreen> {
  // Mock data for the notices
  final List<AdminNotice> _notices = [
    AdminNotice(
      title: 'Mid-Term Exam Schedule Revision',
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Notices', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: false,
        backgroundColor: theme.colorScheme.primary, // Blue app bar
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      // No FloatingActionButton for students
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _notices.length,
        itemBuilder: (context, index) {
          final notice = _notices[index];
          return _buildNoticeCard(context, notice);
        },
      ),
    );
  }

  // Helper widget to build each notice card
  Widget _buildNoticeCard(BuildContext context, AdminNotice notice) {
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
            // No edit/delete buttons for students
          ],
        ),
      ),
    );
  }
}