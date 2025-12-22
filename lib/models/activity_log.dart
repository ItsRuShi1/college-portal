class ActivityLog {
  final String user;
  final String action;
  final DateTime timestamp;

  const ActivityLog({
    required this.user,
    required this.action,
    required this.timestamp,
  });
}