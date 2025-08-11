import 'package:flutter/material.dart';

class Availability {
  final Map<String, TimeRange> weekdayHours;
  final List<DateTime> blackoutDates;

  Availability({required this.weekdayHours, this.blackoutDates = const []});
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});
}
