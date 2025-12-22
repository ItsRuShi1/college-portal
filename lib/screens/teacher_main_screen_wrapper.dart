import 'package:flutter/material.dart';
import 'teacher_dashboard.dart';
import 'teacher_notices_screen.dart'; // Teacher's Notices Management Screen
import 'profile_screen.dart'; // Teacher's Profile Screen
import '../models/user.dart'; // Using your user_model.dart name
import '../utils/constants.dart';

class TeacherMainScreenWrapper extends StatefulWidget {
  final User user;
  const TeacherMainScreenWrapper({super.key, required this.user});

  @override
  State<TeacherMainScreenWrapper> createState() => _TeacherMainScreenWrapperState();
}

class _TeacherMainScreenWrapperState extends State<TeacherMainScreenWrapper> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      // Index 0: Dashboard
      TeacherDashboard(user: widget.user),

      // Index 1: Notices Management
      const TeacherNoticesScreen(),

      // Index 2: Profile
      TeacherProfileScreen(user: widget.user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          // Note: Campaign icon is typically used for Notices/Announcements
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign_rounded),
            label: 'Notices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}