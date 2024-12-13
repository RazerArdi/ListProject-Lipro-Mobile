import 'dart:ui';

class EventTheme {
  final String id;
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final String backgroundImage;
  DateTime startDate;
  DateTime endDate;

  EventTheme({
    required this.id,
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    this.backgroundImage = '',
    required this.startDate,
    required this.endDate,
  });

  // Method to update the start and end dates
  void updateDates(DateTime newStartDate, DateTime newEndDate) {
    startDate = newStartDate;
    endDate = newEndDate;
  }
}