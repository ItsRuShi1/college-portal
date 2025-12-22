import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/timetable_entry.dart';
import '../data/timetable_db.dart';
import '../utils/constants.dart';

class TimetableScreen extends StatefulWidget {
  final bool canEdit;
  const TimetableScreen({super.key, this.canEdit = false});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late DateTime _selectedDate; // The currently tapped day
  late DateTime _currentWeekStart; // The Monday of the currently viewed week
  late List<TimetableEntry> _scheduleForSelectedDay;
  int? _nextClassIndex;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentWeekStart = _getMonday(DateTime.now());
    _loadScheduleForDay(_selectedDate, buildWeek: false);
  }

  // --- Data Loading & Logic ---

  // Helper to get the Monday of any given week
  DateTime _getMonday(DateTime date) {
    int daysToSubtract = date.weekday == 7 ? 6 : date.weekday - 1;
    // Returns a new DateTime object set to 00:00:00 on Monday
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }

  void _loadScheduleForDay(DateTime date, {bool buildWeek = true}) {
    setState(() {
      _selectedDate = date;
      if (buildWeek) {
        _currentWeekStart = _getMonday(date);
      }

      // FIX: Create a new, modifiable list to allow sorting
      _scheduleForSelectedDay = List.from(weeklyTimetableData[date.weekday] ?? []);
      _scheduleForSelectedDay.sort((a, b) => a.startTimeOfDay.compareTo(b.startTimeOfDay));
      _findNextClass(date);
    });
  }

  void _changeWeek(int days) {
    DateTime newWeekDay = _currentWeekStart.add(Duration(days: days));
    // Select the Monday of the new week by default
    _loadScheduleForDay(newWeekDay, buildWeek: true);
  }

  bool _isPast(TimetableEntry entry, DateTime onDay) {
    if (onDay.day != DateTime.now().day || onDay.month != DateTime.now().month || onDay.year != DateTime.now().year) {
      return false;
    }
    final now = TimeOfDay.fromDateTime(DateTime.now());
    return now.compareTo(entry.endTimeOfDay) > 0;
  }

  void _findNextClass(DateTime onDay) {
    _nextClassIndex = null;
    if (onDay.day != DateTime.now().day || onDay.month != DateTime.now().month || onDay.year != DateTime.now().year) {
      return;
    }

    final now = TimeOfDay.fromDateTime(DateTime.now());
    for (int i = 0; i < _scheduleForSelectedDay.length; i++) {
      final entry = _scheduleForSelectedDay[i];
      if (now.compareTo(entry.endTimeOfDay) < 0) {
        _nextClassIndex = i;
        break;
      }
    }
  }

  // --- UI Build Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildWeekSelector(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: _scheduleForSelectedDay.isEmpty
                ? _buildNoClassesView()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _scheduleForSelectedDay.length,
              itemBuilder: (context, index) {
                final entry = _scheduleForSelectedDay[index];
                final bool isPast = _isPast(entry, _selectedDate);
                final bool isNext = (index == _nextClassIndex);

                return Opacity(
                  opacity: isPast ? 0.6 : 1.0,
                  child: _buildTimetableCard(
                      entry,
                      isNext: isNext
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Timetable', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: false, // Left-aligned title
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onBackground),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onBackground), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onBackground), onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 16), onPressed: () => _changeWeek(-7)),
              const Text(
                'This Week',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(icon: const Icon(Icons.arrow_forward_ios, size: 16), onPressed: () => _changeWeek(7)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      height: 90,
      child: Row(
        children: List.generate(7, (index) {
          final day = _currentWeekStart.add(Duration(days: index));

          final isSelected = day.day == _selectedDate.day && day.month == _selectedDate.month;
          final bool hasEvents = (weeklyTimetableData[day.weekday] ?? []).isNotEmpty;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildDateTile(day, isSelected, hasEvents),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDateTile(DateTime date, bool isSelected, bool hasEvents) {
    final dayName = DateFormat('E').format(date);

    return GestureDetector(
      onTap: () {
        _loadScheduleForDay(date, buildWeek: false);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onBackground,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (hasEvents && !isSelected)
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetableCard(TimetableEntry entry, {bool isNext = false}) {
    final Color courseColor = entry.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column (Fixed Width) - 🌟 FIX: Reduced width to prevent overflow
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                entry.startTime,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Course Card (Expanded)
          Expanded(
            child: Card(
              elevation: isNext ? 6 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: isNext
                    ? BorderSide(color: courseColor.withOpacity(0.8), width: 1.5)
                    : BorderSide.none,
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.course, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: courseColor)),
                          const SizedBox(height: 10),
                          Text('Professor: ${entry.professor}'),
                          Text('Location: ${entry.location}'),
                          Text('Time: ${entry.startTime} - ${entry.endTime}'),
                          const SizedBox(height: 20),
                          Center(
                            child: TextButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: courseColor, width: 6)),
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // FIX: Reduced internal horizontal padding
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // FIX: Wrap Text in Expanded for overflow protection
                            Expanded(
                              child: Text(
                                entry.course,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: courseColor,
                                ),
                              ),
                            ),
                            if (isNext)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'NEXT',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.professor,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const Divider(height: 16),
                        // FIX: Row 1 (Time/Location Info) - Removed extra space
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.black54),
                            Expanded(child: Text('${entry.startTime} - ${entry.endTime}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.black54))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // FIX: Row 2 (Location Info)
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16, color: Colors.black54),
                            Expanded(child: Text(entry.location, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, color: Colors.black54))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoClassesView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No classes scheduled for this day.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}