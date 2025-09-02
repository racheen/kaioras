import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/booking_button_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/utils/date_time_utils.dart';

class ButtonLabel {
  static const book = 'Book';
  static const cancel = 'Cancel';
  static const review = 'Review';
  static const waitlisted = 'Waitlisted';
  static const rebook = 'Rebook';
}

class BookingCardWidget extends ConsumerWidget {
  final String title;
  final String? host;
  final DateTime startTime;
  final int duration;
  final String location;
  final String status;
  final String? description;
  final List<String> tags;
  final Block block;

  const BookingCardWidget({
    super.key,
    required this.title,
    this.host,
    required this.startTime,
    required this.duration,
    required this.location,
    required this.status,
    this.description,
    this.tags = const [],
    required this.block,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 800;

    final isAvatarVisible = status != BookingStatus.attended.name;

    if (isMobileView) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                isThreeLine: true,
                leading: Visibility(
                  visible: isAvatarVisible,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/avatar_placeholder.jpg',
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: Text(title),
                subtitle: Text(location),
              ),
              ListTile(
                title: Wrap(
                  children: [
                    Text(
                      '${formatDate(startTime)} ',
                      style: TextStyle(color: AppColors.grey),
                    ),
                    Text(
                      formatTimeRange(
                        startTime,
                        startTime.add(Duration(minutes: duration)),
                      ),
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              Divider(),
              BookingButtonWidget(block: block),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 860,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              width: 250,
                              height: 200,
                              image: AssetImage(
                                'assets/avatar_placeholder3.jpg',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  host ?? 'No name',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: AppColors.violetC2,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                              ),
                                              child: Text(
                                                '${formatDate(startTime)} ${formatTimeRange(startTime, startTime.add(Duration(minutes: duration)))}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_filled,
                                              color: AppColors.violetC2,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                              ),
                                              child: Text('$duration minutes'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              color: AppColors.violetC2,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10.0,
                                              ),
                                              child: Text(location),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 600,
                                child: Text(
                                  description ?? '',
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Visibility(
                        visible: tags.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tags'),
                                  Wrap(
                                    children: tags
                                        .map(
                                          (tag) => Container(
                                            margin: const EdgeInsets.all(8.0),
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: AppColors.violetF6,
                                            ),
                                            child: Text(
                                              tag,
                                              style: TextStyle(
                                                color: AppColors.violet99,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      BookingButtonWidget(block: block),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
