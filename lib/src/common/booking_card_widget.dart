import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/common/cancel_button_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/common/review_button_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';

class ButtonLabel {
  static const book = 'Book';
  static const cancel = 'Cancel';
  static const review = 'Review';
  static const waitlisted = 'Waitlisted';
}

class BookingCardWidget extends StatelessWidget {
  final String title;
  final String? host;
  final String startTime;
  final String? duration;
  final String location;
  final String status;
  final String? description;
  final List<String> tags;
  final String? price;
  final Function? callback;
  final Function? cancelCallback;
  final Block? block;

  const BookingCardWidget({
    super.key,
    required this.title,
    this.host,
    required this.startTime,
    this.duration,
    required this.location,
    required this.status,
    this.description,
    this.tags = const [],
    this.price,
    this.callback,
    this.cancelCallback,
    this.block,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 800;

    final isAvatarVisible = status != BookingStatus.attended.name;

    String buttonLabel = ButtonLabel.book;
    final uid = 'user001';
    print(block?.isUserBooked(uid));
    final isUserBooked = block?.isUserBooked(uid);
    final isUserWaitlisted = block?.isUserWaitlisted(uid);
    final isUserAttended = block?.isUserAttended(uid);

    if (isUserBooked ?? false) {
      buttonLabel = ButtonLabel.cancel;
    } else if (isUserAttended ?? false) {
      buttonLabel = ButtonLabel.review;
    } else if (isUserWaitlisted ?? false) {
      buttonLabel = ButtonLabel.waitlisted;
    } else {
      buttonLabel = ButtonLabel.book;
    }

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
                title: Text(startTime, style: TextStyle(color: AppColors.grey)),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    switch (buttonLabel) {
                      case ButtonLabel.cancel:
                        return CancelButtonWidget(callback: cancelCallback!);
                      case ButtonLabel.review:
                        return ReviewButtonWidget();
                      default:
                        return ElevatedButton(
                          onPressed: () {
                            // todo: implement book functionality
                            if (!isUserBooked!) {
                              if (callback != null) {
                                callback!();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.violetC2,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(buttonLabel),
                        );
                    }
                  },
                ),
              ),
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
                                              child: Text(startTime),
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
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '\$ $price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 150,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Builder(
                              builder: (context) {
                                switch (buttonLabel) {
                                  case ButtonLabel.cancel:
                                    return CancelButtonWidget(
                                      callback: cancelCallback!,
                                    );
                                  case ButtonLabel.review:
                                    return ReviewButtonWidget();
                                  default:
                                    return ElevatedButton(
                                      onPressed: () {
                                        // todo: implement book functionality
                                        if (!isUserBooked!) {
                                          if (callback != null) {
                                            callback!();
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.violetC2,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.grey,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        minimumSize: Size(double.infinity, 50),
                                      ),
                                      child: Text(buttonLabel),
                                    );
                                }
                              },
                            ),
                          ),
                          // FloatingActionButton.extended(
                          //   elevation: 1,
                          //   onPressed: () {
                          //     // todo: implement book functionality
                          //     if (!isUserBooked! && callback != null) {
                          //       callback!();
                          //     } else {
                          //       print('cancel');
                          //     }
                          //   },
                          //   label: Text(buttonLabel),
                          //   backgroundColor: AppColors.violetC2,
                          //   foregroundColor: Colors.white,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          // ),
                        ),
                      ),
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
