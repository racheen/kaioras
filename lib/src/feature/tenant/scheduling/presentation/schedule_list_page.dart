import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/schedule_list_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/firebase_blocks_repository.dart';
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
    final currentAppUserAsync = ref.watch(currentAppUserProvider);

    return currentAppUserAsync.when(
      data: (currentAppUser) {
        if (currentAppUser == null || currentAppUser.roles.isEmpty) {
          return Center(child: Text('No user data available'));
        }

        final businessId = currentAppUser.roles.keys.firstOrNull;
        if (businessId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Schedule')),
            body: Center(
              child: Text('No business associated with this account'),
            ),
          );
        }
        final blocksAsync = ref.watch(
          blocksHostedProvider((businessId, currentAppUser.uid)),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Schedule'),
            actions: [
              TextButton(
                onPressed: () {
                  blocksAsync.whenData((blocks) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScheduleForm(existingBlocks: blocks),
                      ),
                    );
                  });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Create New Block'),
              ),
            ],
          ),
          body: blocksAsync.when(
            data: (schedules) {
              if (schedules.isEmpty) {
                return Center(child: Text('No schedules available'));
              }

              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final tomorrow = today.add(Duration(days: 1));
              final todaysSchedules = schedules
                  .where(
                    (s) =>
                        s.startTime!.isAfter(today) &&
                        s.startTime!.isBefore(tomorrow),
                  )
                  .toList();
              final upcomingSchedules = schedules
                  .where((s) => s.startTime!.isAfter(tomorrow))
                  .toList();
              final pastSchedules = schedules
                  .where((s) => s.startTime!.isBefore(today))
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
                                      top: BorderSide(
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      schedule.title ?? 'No Block Title',
                                      style: TextStyle(
                                        color: AppColors.violet99,
                                      ),
                                    ),
                                    subtitle: Text(
                                      schedule.host?.name ?? 'No Host Name',
                                    ),
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
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
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
          body: schedules.isEmpty
              ? Center(child: Text('No schedules available for this period'))
              : ScheduleList(
                  isUpcomingSchedule: title != 'Past',
                  schedules: schedules,
                ),
          isExpanded: isExpanded,
        ),
      ],
    );
  }
}
