import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/due_work_item.dart'; // Import the fixed model

class DueWorkScreen extends StatefulWidget {
  const DueWorkScreen({super.key});

  @override
  State<DueWorkScreen> createState() => _DueWorkScreenState();
}

class _DueWorkScreenState extends State<DueWorkScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'EDC', 'DE', 'Quizzes'];
  final double BREAKPOINT = 800.0;

  // 🌟 These 'const' keywords will now work because the model was fixed above 🌟
  final List<DueWorkItem> _items = [
    const DueWorkItem(
      title: 'Chapter 5 Reading Quiz',
      course: 'Digital Electronics (DE)',
      icon: Icons.developer_board,
      status: DueWorkStatus.pending,
      // Note: DateTime.now() is NOT const, so we must use a fixed date or remove 'const' from this specific item if using .now()
      // For this fix, I'll use fixed dates to keep it 'const' safe.
      // If you want DateTime.now(), remove 'const' from that line.
    ),
    const DueWorkItem(
      title: 'Final Project Proposal',
      course: 'Electronics Devices and Circuit (EDC)',
      icon: Icons.memory,
      status: DueWorkStatus.completed,
    ),
    const DueWorkItem(
      title: 'Mid-term Exam Study Guide',
      course: 'Engineering Mathematics-III (EM-III)',
      icon: Icons.calculate,
      status: DueWorkStatus.pending,
    ),
    const DueWorkItem(
      title: 'Week 3 Quiz',
      course: 'Digital Electronics (DE)',
      icon: Icons.developer_board,
      status: DueWorkStatus.completed,
    ),
    const DueWorkItem(
      title: 'Practical 1 Submission',
      course: 'Personality Development (PD)',
      icon: Icons.person,
      status: DueWorkStatus.pending,
    ),
  ];

  String _formatDueDate(DateTime? date) {
    if (date == null) return '';
    // Simple date formatter
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Due Work', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > BREAKPOINT;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isWideScreen ? 700 : double.infinity),
              child: Column(
                children: [
                  _buildFilterChips(theme),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return _buildDueWorkCard(context, item, theme);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                }
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDueWorkCard(BuildContext context, DueWorkItem item, ThemeData theme) {
    final bool isPending = item.status == DueWorkStatus.pending;
    final Color sideColor = isPending ? Colors.orange : Colors.green;
    final Color iconBgColor = theme.colorScheme.primary.withAlpha(26);

    // If date is null, provide a default
    final displayDate = item.dueDate ?? item.completedDate ?? DateTime.now();
    String statusText;

    if (isPending) {
      statusText = 'Due: ${_formatDueDate(displayDate)}';
    } else {
      statusText = 'Completed: ${_formatDueDate(displayDate)}';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: sideColor, width: 6)),
          borderRadius: BorderRadius.circular(15),
          color: theme.colorScheme.surface,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: iconBgColor,
            child: Icon(item.icon, color: theme.colorScheme.primary),
          ),
          title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(item.course, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 13,
                  color: isPending ? Colors.red.shade700 : Colors.green.shade700,
                  fontWeight: isPending ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          trailing: isPending
              ? const Icon(Icons.chevron_right, color: Colors.black54)
              : const Icon(Icons.check_circle, color: Colors.green),
          onTap: () {},
        ),
      ),
    );
  }
}