import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'package:intl/intl.dart';

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

bool isTimeRangeAvailable(
  DateTime startTime,
  int duration,
  Availability studioAvailability,
  List<Block> existingBlocks,
) {
  final endTime = startTime.add(Duration(minutes: duration));
  final weekday = DateFormat('EEEE').format(startTime);

  // Check if the entire duration is within the studio's availability
  final availableHours = studioAvailability.weekdayHours[weekday];
  if (availableHours == null) return false;

  final availableStart = DateTime(
    startTime.year,
    startTime.month,
    startTime.day,
    availableHours.start.hour,
    availableHours.start.minute,
  );
  final availableEnd = DateTime(
    startTime.year,
    startTime.month,
    startTime.day,
    availableHours.end.hour,
    availableHours.end.minute,
  );

  if (startTime.isBefore(availableStart) || endTime.isAfter(availableEnd)) {
    return false;
  }

  // Check for overlap with existing blocks
  for (final block in existingBlocks) {
    final blockStart = block.startTime!;
    final blockEnd = blockStart.add(Duration(minutes: block.duration!));

    if (startTime.isBefore(blockEnd) && endTime.isAfter(blockStart)) {
      return false;
    }
  }

  return true;
}
