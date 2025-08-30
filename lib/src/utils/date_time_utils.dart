import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final day = date.day.toString().padLeft(2, '0');
  final month = months[date.month - 1];
  final year = date.year.toString();
  return '$month $day, $year';
}

String formatTimeRange(DateTime start, DateTime end) {
  return "${formatTime(start)} - ${formatTime(end)}";
}

String formatTime(DateTime time) {
  final localTime = TimeOfDay.fromDateTime(time);
  final hour = localTime.hourOfPeriod == 0 ? 12 : localTime.hourOfPeriod;
  final minute = localTime.minute.toString().padLeft(2, '0');
  final period = localTime.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

int daysBetweenfromToday(DateTime toDate) {
  DateTime fromDate = DateTime.now();
  toDate = DateTime(toDate.year, toDate.month, toDate.day);

  return (toDate.difference(fromDate).inHours / 24).round();
}
