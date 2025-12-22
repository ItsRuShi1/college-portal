import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'custom_button.dart';
import '../models/user.dart';
import 'main_screen_wrapper.dart';
import 'teacher_main_screen_wrapper.dart';
import 'admin_main_screen_wrapper.dart';
import '../utils/constants.dart';
import '../data/student_data_db.dart';
import '../models/student_data.dart';
import '../data/grade_report_db.dart';
import '../models/grade_report.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  String selectedRole = 'Student';
  String? _error;

  void _login() {
    setState(() => _error = null);
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text.trim();

    final user = demoUsers.firstWhere(
          (u) => u.username == username && u.password == password,
      orElse: () => const User(username: '', password: '', role: '', name: ''),
    );

    if (user.username.isEmpty) {
      setState(() => _error = 'Invalid username or password.');
      return;
    }

    if (user.role.toLowerCase() != selectedRole.toLowerCase()) {
      setState(() => _error = 'Role mismatch. Please select the correct role.');
      return;
    }

    // Navigate based on role
    if (user.role.toLowerCase() == 'student') {
      final studentData = studentDatabase[user.username];
      final gradeReport = gradeDatabase[user.username];

      if (studentData == null || gradeReport == null) {
        setState(() => _error = 'Could not find dashboard data for this user.');
        return;
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => MainScreenWrapper(
                user: user,
                studentData: studentData,
                gradeReport: gradeReport,
              )
          )
      );
    } else if (user.role.toLowerCase() == 'teacher') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => TeacherMainScreenWrapper(user: user)));
    } else if (user.role.toLowerCase() == 'admin') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => AdminMainScreenWrapper(user: user)));
    }
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onBackgroundColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        // 🌟 FIX: Center and constrain the form content for desktop
        child: Center(
          // Constrains the form width on wide screens
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            // The SingleChildScrollView handles keyboard avoidance on mobile
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Classroom Portal',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: onBackgroundColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logo container
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: primaryColor.withOpacity(0.1),
                      image: const DecorationImage(
                        image: AssetImage('assets/college_png1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Role Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightField,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: ['Student', 'Teacher', 'Admin'].map((role) {
                        bool selected = selectedRole == role;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedRole = role),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selected ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  role,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: selected
                                        ? Colors.black
                                        : Colors.blueGrey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Username Field
                  TextField(
                    controller: _userCtrl,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: AppColors.lightField,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: AppColors.lightField,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_error!,
                          style: const TextStyle(color: Colors.red, fontSize: 14)),
                    ),

                  const SizedBox(height: 16),

                  // Login Button
                  CustomButton(label: 'LOGIN', onPressed: _login, color: primaryColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}