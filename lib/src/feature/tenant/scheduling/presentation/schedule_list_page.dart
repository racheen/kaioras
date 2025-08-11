import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/expandable_section_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/schedule_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/schedule.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/schedule_form_page.dart';
import 'package:flutter_riverpod_boilerplate/src/common/schedule_list_widget.dart';

class ScheduleListPage extends ConsumerWidget {
  const ScheduleListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instructorEventsAsync = ref.watch(
      instructorEventsProvider('user005'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScheduleForm()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('New Class'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: instructorEventsAsync.when(
          data: (schedules) {
            final upcomingSchedules = schedules
                .where((s) => s.startTime.isAfter(DateTime.now()))
                .toList();
            final pastSchedules = schedules
                .where((s) => s.startTime.isBefore(DateTime.now()))
                .toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandableSection(
                  title: 'Upcoming',
                  schedules: upcomingSchedules,
                  isUpcoming: true,
                ),
                const SizedBox(height: 20),
                ExpandableSection(
                  title: 'Past',
                  schedules: pastSchedules,
                  isUpcoming: false,
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
