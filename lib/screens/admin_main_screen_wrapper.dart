import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'manage_notices_screen.dart'; // Admin's "Manage Notices" screen
import 'profile_screen.dart'; // Re-using Teacher profile for Admin
import '../models/user.dart';
import '../utils/constants.dart';

class AdminMainScreenWrapper extends StatefulWidget {
  final User user;
  const AdminMainScreenWrapper({super.key, required this.user});

  @override
  State<AdminMainScreenWrapper> createState() => _AdminMainScreenWrapperState();
}

class _AdminMainScreenWrapperState extends State<AdminMainScreenWrapper> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      // Index 0: Admin Dashboard
      AdminDashboard(user: widget.user),

      // Index 1: Manage Notices
      const ManageNoticesScreen(),

      // Index 2: Profile (Using TeacherProfile as a placeholder)
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