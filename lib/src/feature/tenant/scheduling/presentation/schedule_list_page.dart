import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/schedule_list_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/fake_blocks_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/schedule_form_page.dart';

class ScheduleListPage extends ConsumerStatefulWidget {
  const ScheduleListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends ConsumerState<ScheduleListPage> {
  bool todaysSchedulesIsExpanded = true;
  bool upcomingSchedulesIsExpanded = true;
  bool pastSchedulesIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final instructorEventsAsync = ref.watch(
      instructorEventsProvider('user001'),
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
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = today.add(Duration(days: 1));

            final todaysSchedules = schedules
                .where(
                  (s) =>
                      s.startTime.isAfter(today) &&
                      s.startTime.isBefore(tomorrow),
                )
                .toList();
            final upcomingSchedules = schedules
                .where((s) => s.startTime.isAfter(tomorrow))
                .toList();
            final pastSchedules = schedules
                .where((s) => s.startTime.isBefore(today))
                .toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildExpansionPanel(
                    'Today\'s Schedule',
                    todaysSchedules,
                    todaysSchedulesIsExpanded,
                    (_, isExpanded) => setState(
                      () => todaysSchedulesIsExpanded =
                          !todaysSchedulesIsExpanded,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildExpansionPanel(
                    'Upcoming',
                    upcomingSchedules,
                    upcomingSchedulesIsExpanded,
                    (_, isExpanded) => setState(
                      () => upcomingSchedulesIsExpanded =
                          !upcomingSchedulesIsExpanded,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          pastSchedulesIsExpanded = !pastSchedulesIsExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    'Past',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              },
                          body: Column(
                            children: pastSchedules.map((schedule) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppColors.lightGrey),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    schedule.title,
                                    style: TextStyle(color: AppColors.violet99),
                                  ),
                                  subtitle: Text(schedule.host.name),
                                  trailing: Text(
                                    schedule.startTime.toString(),
                                    style: TextStyle(
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                  onTap: () {
                                    // Handle tap on past schedule
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          isExpanded: pastSchedulesIsExpanded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildExpansionPanel(
    String title,
    List<Block> schedules,
    bool isExpanded,
    ExpansionPanelCallback callback,
  ) {
    return ExpansionPanelList(
      expansionCallback: callback,
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            );
          },
          body: ScheduleList(
            isUpcomingSchedule: title != 'Past',
            schedules: schedules,
          ),
          isExpanded: isExpanded,
        ),
      ],
    );
  }
}
