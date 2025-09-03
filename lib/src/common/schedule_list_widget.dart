import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/common/inline_calendar/inline_calendar.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/utils/date_time_utils.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({
    super.key,
    this.isUpcomingSchedule = false,
    required this.schedules,
  });

  final bool? isUpcomingSchedule;
  final List<Block> schedules;

  final double _minHeight = 360;

  @override
  Widget build(BuildContext context) {
    final groupedSchedules = groupSchedulesByDate(schedules);

    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in groupedSchedules.entries) ...[
              // Date header
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  formatDate(entry.key),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
              ),
              // Schedule items for this date
              ...entry.value.asMap().entries.map((mapEntry) {
                final index = mapEntry.key;
                final schedule = mapEntry.value;
                final isGreen = index % 2 == 0;
                return ScheduleItem(
                  color: EventColor(
                    isGreen ? AppColors.greenF7 : AppColors.violetFB,
                    isGreen ? AppColors.green63 : AppColors.violet99,
                    isGreen ? AppColors.green92 : AppColors.violetC2,
                  ),
                  data: schedule,
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<Block>> groupSchedulesByDate(List<Block> schedules) {
    final groupedSchedules = <DateTime, List<Block>>{};
    for (final schedule in schedules) {
      final date = DateTime(
        schedule.startTime!.year,
        schedule.startTime!.month,
        schedule.startTime!.day,
      );
      if (!groupedSchedules.containsKey(date)) {
        groupedSchedules[date] = [];
      }
      groupedSchedules[date]!.add(schedule);
    }
    return Map.fromEntries(
      groupedSchedules.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}

Map<DateTime, List<Block>> groupSchedulesByDate(List<Block> schedules) {
  final groupedSchedules = <DateTime, List<Block>>{};
  for (final schedule in schedules) {
    final date = DateTime(
      schedule.startTime!.year,
      schedule.startTime!.month,
      schedule.startTime!.day,
    );
    if (!groupedSchedules.containsKey(date)) {
      groupedSchedules[date] = [];
    }
    groupedSchedules[date]!.add(schedule);
  }
  return groupedSchedules;
}

class ScheduleItem extends StatelessWidget {
  final EventColor color;
  final Block data;

  const ScheduleItem({super.key, required this.color, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final primaryColor = color.primaryColor;
    final secondaryColor = color.secondaryColor;
    final backgroundColor = color.backgroundColor;

    final title = "${data.title} • ${data.location}";
    final startTime = data.startTime!;
    final duration = data.duration ?? 0;
    final endTime = startTime.add(Duration(minutes: duration));
    final subtitle = formatTimeRange(startTime, endTime);
    final label = formatTime(startTime);

    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 10.0),
      child: SizedBox(
        width: screenWidth,
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              width: 80.0,
              child: Text(
                label,
                style: const TextStyle(color: AppColors.lightGrey),
              ),
            ),
            const VerticalDivider(
              width: 20,
              thickness: 1,
              endIndent: 0,
              color: AppColors.lightGrey,
            ),
            Flexible(
              child: Container(
                width: screenWidth * 0.7,
                height: 80.0,
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border(
                    left: BorderSide(color: primaryColor, width: 5.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventColor {
  Color backgroundColor;
  Color primaryColor;
  Color secondaryColor;

  EventColor(this.backgroundColor, this.primaryColor, this.secondaryColor);
}
