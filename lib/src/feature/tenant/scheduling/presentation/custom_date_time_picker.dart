import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:intl/intl.dart';

Future<DateTime?> showCustomDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required Availability studioAvailability,
  required List<TimeRange> existingBlocks,
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
      final TimeOfDay? time = await showCustomTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        availableStart: availableHours.start,
        availableEnd: availableHours.end,
        existingBlocks: existingBlocks,
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

Future<TimeOfDay?> showCustomTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  required TimeOfDay availableStart,
  required TimeOfDay availableEnd,
  required List<TimeRange> existingBlocks,
}) {
  return showDialog<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return CustomTimePickerDialog(
        initialTime: initialTime,
        availableStart: availableStart,
        availableEnd: availableEnd,
        existingBlocks: existingBlocks,
      );
    },
  );
}

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final TimeOfDay availableStart;
  final TimeOfDay availableEnd;
  final List<TimeRange> existingBlocks;

  const CustomTimePickerDialog({
    Key? key,
    required this.initialTime,
    required this.availableStart,
    required this.availableEnd,
    required this.existingBlocks,
  }) : super(key: key);

  @override
  _CustomTimePickerDialogState createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  List<TimeOfDay> _generateAvailableTimes() {
    List<TimeOfDay> slots = [];
    TimeOfDay current = widget.availableStart;
    while (current.hour < widget.availableEnd.hour ||
        (current.hour == widget.availableEnd.hour &&
            current.minute <= widget.availableEnd.minute)) {
      if (!isTimeSlotOccupied(current)) {
        slots.add(current);
      } else {
        print('Occupied time slot: ${current.format(context)}');
      }
      current = current.replacing(
        minute: (current.minute + 15) % 60,
        hour: current.minute + 15 >= 60
            ? (current.hour + 1) % 24
            : current.hour,
      );
    }
    return slots;
  }

  bool isTimeSlotOccupied(TimeOfDay time) {
    bool occupied = widget.existingBlocks.any((block) {
      bool isOccupied =
          (time.hour > block.start.hour ||
              (time.hour == block.start.hour &&
                  time.minute >= block.start.minute)) &&
          (time.hour < block.end.hour ||
              (time.hour == block.end.hour && time.minute < block.end.minute));

      return isOccupied;
    });

    return occupied;
  }

  @override
  Widget build(BuildContext context) {
    final availableTimes = _generateAvailableTimes();

    return AlertDialog(
      title: Text('Select Time'),
      content: Container(
        width: 300,
        height: 300,
        child: ListView.builder(
          itemCount: availableTimes.length,
          itemBuilder: (context, index) {
            final time = availableTimes[index];
            return ListTile(
              title: Text(time.format(context)),
              tileColor: _selectedTime == time
                  ? Colors.blue.withOpacity(0.2)
                  : null,
              onTap: () {
                setState(() {
                  _selectedTime = time;
                });
              },
            );
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(_selectedTime),
        ),
      ],
    );
  }
}

bool isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
  final now = DateTime.now();
  final timeDate = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );
  final startDate = DateTime(
    now.year,
    now.month,
    now.day,
    start.hour,
    start.minute,
  );
  final endDate = DateTime(now.year, now.month, now.day, end.hour, end.minute);

  return timeDate.isAfter(startDate) && timeDate.isBefore(endDate);
}
