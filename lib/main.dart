import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import package
import 'screens/login_screen.dart';
import 'utils/constants.dart';

final GlobalKey<_ClassroomAppState> classroomAppKey = GlobalKey();

void main() async {
  // Required to ensure plugin services are initialized before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Load the theme preference from storage
  final prefs = await SharedPreferences.getInstance();
  final bool isDark = prefs.getBool('isDarkMode') ?? false;

  runApp(ClassroomApp(key: classroomAppKey, initialDarkMode: isDark));
}

class ClassroomApp extends StatefulWidget {
  final bool initialDarkMode;
  const ClassroomApp({super.key, required this.initialDarkMode});

  static void toggleTheme(BuildContext context) {
    final state = context.findAncestorStateOfType<_ClassroomAppState>();
    state?.setThemeMode(!state._isDarkMode);
  }

  @override
  State<ClassroomApp> createState() => _ClassroomAppState();
}

class _ClassroomAppState extends State<ClassroomApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    // Initialize state from the value passed from main()
    _isDarkMode = widget.initialDarkMode;
  }

  // Updated method to save to disk whenever the theme is changed
  Future<void> setThemeMode(bool isDark) async {
    setState(() {
      _isDarkMode = isDark;
    });

    // Persist the choice to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classroom Portal',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.darkSurface,
          background: AppColors.darkBackground,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        useMaterial3: true,
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
    );
  }
}