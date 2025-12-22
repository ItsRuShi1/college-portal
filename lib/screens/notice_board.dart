import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Run 'flutter pub add intl'
import '../models/notice_model.dart';

class NoticesScreen extends StatefulWidget {
  const NoticesScreen({super.key});

  @override
  State<NoticesScreen> createState() => _NoticesScreenState();
}

class _NoticesScreenState extends State<NoticesScreen> {
  // Mock data for the notices
  final List<Notice> _notices = [
    Notice(
      title: 'Mid-Term Exam Schedule Revision',
      body: 'Please note that the schedule for the upcoming mid-term examinations has been updated. All students and faculty are requested to refer to the new timetable available on the portal.',
      postDate: DateTime(2025, 10, 26),
    ),
    Notice(
      title: 'Annual Sports Day Announcement',
      body: 'Get ready for the most awaited event of the year! The Annual Sports Day will be held on the 15th of November. Registrations are now open for all events.',
      postDate: DateTime(2025, 10, 24),
    ),
    Notice(
      title: 'Library Closure for Maintenance',
      body: 'The central library will be closed for annual maintenance from November 1st to November 5th. Please return all borrowed books by October 31st.',
      postDate: DateTime(2025, 10, 22),
    ),
  ];

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
            onPressed: () {
              // Handle search action
            },
          ),
        ],
      ),
      // Use FloatingActionButton.extended for the button with text
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle "Post New Notice" action
        },
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
          return _buildNoticeCard(context, notice);
        },
      ),
    );
  }

  // Helper widget to build each notice card
  Widget _buildNoticeCard(BuildContext context, Notice notice) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('MMM d, yyyy').format(notice.postDate);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                height: 1.5, // Improves readability
              ),
            ),
            const SizedBox(height: 12),

            // Footer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Posted on: $formattedDate',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle "View Details"
                      },
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.black54),
                      onPressed: () {
                        // Handle more options
                      },
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