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

  factory Availability.fromMap(Map<String, dynamic> map) {
    return Availability(
      weekdayHours: (map['weekdayHours'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          TimeRange(
            start: TimeOfDay(
              hour: int.parse(value['start'].split(':')[0]),
              minute: int.parse(value['start'].split(':')[1]),
            ),
            end: TimeOfDay(
              hour: int.parse(value['end'].split(':')[0]),
              minute: int.parse(value['end'].split(':')[1]),
            ),
          ),
        ),
      ),
      blackoutDates: (map['blackoutDates'] as List)
          .map((date) => DateTime.parse(date as String))
          .toList(),
      timeZone: map['timeZone'] as String,
      closedDays: List<String>.from(map['closedDays']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weekdayHours': weekdayHours.map(
        (key, value) => MapEntry(key, {
          'start':
              '${value.start.hour.toString().padLeft(2, '0')}:${value.start.minute.toString().padLeft(2, '0')}',
          'end':
              '${value.end.hour.toString().padLeft(2, '0')}:${value.end.minute.toString().padLeft(2, '0')}',
        }),
      ),
      'blackoutDates': blackoutDates
          .map((date) => date.toIso8601String())
          .toList(),
      'timeZone': timeZone,
      'closedDays': closedDays,
    };
  }
}

class TimeRange {
  final TimeOfDay start;
  final TimeOfDay end;

  TimeRange({required this.start, required this.end});
  factory TimeRange.fromMap(Map<String, dynamic> map) {
    return TimeRange(
      start: TimeOfDay(
        hour: int.parse(map['start'].split(':')[0]),
        minute: int.parse(map['start'].split(':')[1]),
      ),
      end: TimeOfDay(
        hour: int.parse(map['end'].split(':')[0]),
        minute: int.parse(map['end'].split(':')[1]),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start':
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      'end':
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
    };
  }
}
