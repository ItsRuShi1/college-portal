import 'package:flutter/material.dart';
import 'student_dashboard.dart';
import 'timetable_screen.dart';
import 'grades_screen.dart';
import 'student_profile_screen.dart';
import '../models/user.dart';
import '../models/student_data.dart';
import '../models/grade_report.dart';

// Helper class for navigation items
class NavItem {
  final IconData icon;
  final String label;
  final Widget screen;

  const NavItem({required this.icon, required this.label, required this.screen});
}

class MainScreenWrapper extends StatefulWidget {
  final User user;
  final StudentData studentData;
  final GradeReport gradeReport;

  const MainScreenWrapper({
    super.key,
    required this.user,
    required this.studentData,
    required this.gradeReport,
  });

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;
  late final List<NavItem> _navItems;
  final double BREAKPOINT = 600.0; // Desktop/Tablet breakpoint

  @override
  void initState() {
    super.initState();

    // Define all navigation destinations and their corresponding screens
    _navItems = [
      NavItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        screen: StudentDashboard(
          user: widget.user,
          studentData: widget.studentData,
          gradeReport: widget.gradeReport,
        ),
      ),
      NavItem(
        icon: Icons.calendar_today,
        label: 'Timetable',
        screen: TimetableScreen(),
      ),
      NavItem(
        icon: Icons.grade,
        label: 'Grades',
        screen: GradesScreen(gradeReport: widget.gradeReport),
      ),
      NavItem(
        icon: Icons.person,
        label: 'Profile',
        screen: StudentProfileScreen(user: widget.user),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to check screen constraints dynamically
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > BREAKPOINT) {
          // WIDE SCREEN (Desktop/Tablet Landscape)
          return _buildWideLayout(context);
        } else {
          // COMPACT SCREEN (Mobile)
          return _buildCompactLayout(context);
        }
      },
    );
  }

  // --- Layout Builders ---

  // Mobile layout uses the bottom navigation bar
  Widget _buildCompactLayout(BuildContext context) {
    return Scaffold(
      body: _navItems[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems.map((item) => BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        )).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Desktop layout uses the NavigationRail (Side Bar)
  Widget _buildWideLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 1. Navigation Rail (Side Bar)
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: _navItems.map((item) => NavigationRailDestination(
              icon: Icon(item.icon),
              label: Text(item.label),
            )).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),

          // 2. Main Content Area (Constrained for readability)
          Expanded(
            child: Center(
              // Constrain the content to a maximum readable width (e.g., 900px)
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: _navItems[_selectedIndex].screen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}