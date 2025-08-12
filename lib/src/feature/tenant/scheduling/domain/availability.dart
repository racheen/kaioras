import 'package:flutter/material.dart';

class Availability {
  final Map<String, TimeRange> weekdayHours;
  final List<DateTime> blackoutDates;
  final String timeZone;
  final List<String> closedDays;

  Availability({
    required this.weekdayHours,
    this.blackoutDates = const [],
    required this.timeZone,
    required this.closedDays,
  });
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});
}
