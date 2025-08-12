import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:intl/intl.dart';

Future<DateTime?> showCustomDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required Availability studioAvailability,
}) async {
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    selectableDayPredicate: (DateTime day) {
      final weekday = DateFormat('EEEE').format(day);
      return studioAvailability.weekdayHours.containsKey(weekday) &&
          !studioAvailability.blackoutDates.contains(day);
    },
  );

  if (date != null) {
    final weekday = DateFormat('EEEE').format(date);
    final availableHours = studioAvailability.weekdayHours[weekday];
    if (availableHours != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (time != null) {
        return DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  return null;
}
