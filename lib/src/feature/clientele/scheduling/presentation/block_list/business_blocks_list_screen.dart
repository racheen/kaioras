import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/common/booking_card_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/helper.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/blocks_list_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

class BusinessBlocksList extends ConsumerStatefulWidget {
  final String? businessId;

  const BusinessBlocksList({super.key, required this.businessId});

  @override
  ConsumerState<BusinessBlocksList> createState() => _BlocksListState();
}

class _BlocksListState extends ConsumerState<BusinessBlocksList> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentWeekTimeline = getMondayOfCurrentWeek();

  @override
  void initState() {
    super.initState();

    if (widget.businessId!.isEmpty) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 800;

    final blocksAsyncValue = ref.watch(
      blocksListControllerProvider(widget.businessId!),
    );

    return Scaffold(
      body: ListView(
        children: [
          AsyncValueWidget(
            value: blocksAsyncValue,
            data: (blocks) => Container(
              margin: const EdgeInsets.all(50.0),
              width: 1080,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                        'assets/avatar_placeholder2.jpg',
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(blocks[0]!.tenant.toString()),
                  ),
                  Column(
                    children: [
                      EasyDateTimeLinePicker(
                        firstDate: _currentWeekTimeline,
                        lastDate: _currentWeekTimeline.add(Duration(days: 6)),
                        headerOptions: HeaderOptions(
                          headerType: HeaderType.viewOnly,
                        ),
                        focusedDate: _selectedDate,
                        timelineOptions: TimelineOptions(
                          padding: EdgeInsets.all(10),
                        ),
                        selectionMode: SelectionMode.autoCenter(),
                        itemExtent: 50,
                        onDateChange: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentWeekTimeline = _currentWeekTimeline
                                    .subtract(Duration(days: 7));
                              });
                            },
                            icon: Icon(Icons.arrow_circle_left_rounded),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _currentWeekTimeline = _currentWeekTimeline.add(
                                  Duration(days: 7),
                                );
                              });
                            },
                            icon: Icon(Icons.arrow_circle_right_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: blocks
                        .map(
                          (block) => GestureDetector(
                            child: BookingCardWidget(
                              title: block!.title.toString(),
                              host: block.host!.name.toString(),
                              startTime: block.startTime.toString(),
                              duration: block.duration.toString(),
                              location: block.location.toString(),
                              status: block.status.toString(),
                              description: block.description.toString(),
                              tags: block.tags!,
                              price: '60',
                            ),
                            onTap: () {
                              if (isMobileView) {
                                context.goNamed(
                                  ClienteleRoute.block.name,
                                  pathParameters: {
                                    'businessId': block.businessId.toString(),
                                    'blockId': block.blockId.toString(),
                                  },
                                );
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
