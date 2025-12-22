enum AttendanceStatus {present,abesent}
class StudentRoster {
  final String name;
  final String id;
  bool isPresent;

  StudentRoster({
    required this.name,
    required this.id,
    this.isPresent = true, // Default to present
  });
}