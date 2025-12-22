import 'package:flutter/material.dart';
import 'custom_button.dart';

class PostNoticeFormScreen extends StatefulWidget {
  const PostNoticeFormScreen({super.key});

  @override
  State<PostNoticeFormScreen> createState() => _PostNoticeFormScreenState();
}

class _PostNoticeFormScreenState extends State<PostNoticeFormScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = ['Academics', 'Events', 'Campus', 'General'];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submitNotice() {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    // In a real app, this data would be sent to the database.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Posted notice: ${_titleController.text} in category $_selectedCategory')),
    );
    Navigator.pop(context); // Go back to the dashboard/notices list
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Post New Notice', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notice Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Category Dropdown
            _buildFormLabel('Category'),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: _buildInputDecoration(hint: 'Select Category'),
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() => _selectedCategory = newValue);
              },
            ),
            const SizedBox(height: 16),

            // Title
            _buildFormLabel('Title'),
            TextField(
              controller: _titleController,
              decoration: _buildInputDecoration(hint: 'Mid-term Examination Schedule'),
            ),
            const SizedBox(height: 16),

            // Body/Description
            _buildFormLabel('Content'),
            TextField(
              controller: _bodyController,
              maxLines: 8,
              decoration: _buildInputDecoration(hint: 'Write the full announcement body here...'),
            ),
            const SizedBox(height: 30),

            CustomButton(
              label: 'Post Notice',
              onPressed: _submitNotice,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Form Helpers
  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
    );
  }

  InputDecoration _buildInputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
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