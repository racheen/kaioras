import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/common/schedule_list_widget.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final List<Block> schedules;
  final bool isUpcoming;

  const ExpandableSection({
    Key? key,
    required this.title,
    required this.schedules,
    required this.isUpcoming,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          childrenPadding: EdgeInsets.zero,
          children: [
            ScheduleList(isUpcomingSchedule: isUpcoming, schedules: schedules),
          ],
        ),
      ),
    );
  }
}
