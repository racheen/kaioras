import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/cancel_button_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/common/review_button_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_notifier.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class ButtonLabel {
  static const book = 'Book';
  static const cancel = 'Cancel';
  static const review = 'Review';
  static const waitlisted = 'Waitlisted';
  static const rebook = 'Rebook';
}

class BookingButtonWidget extends ConsumerWidget {
  final Function? callback;
  final Function? cancelCallback;
  final Block block;

  const BookingButtonWidget({
    super.key,
    this.callback,
    this.cancelCallback,
    required this.block,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FToast fToast = FToast();
    fToast.init(context);

    showToast(message) {
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.green92,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 12.0),
            Text(message, style: TextStyle(color: Colors.white)),
          ],
        ),
      );

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM_RIGHT,
        toastDuration: Duration(seconds: 5),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 800;

    String buttonLabel;

    final userBookings = ref.watch(bookingsNotifierProvider);

    bool checkStatus(bookingStatus) {
      for (var booking in userBookings) {
        if (booking.containsKey(block.blockId) &&
            booking.containsValue(bookingStatus)) {
          return true;
        }
      }
      return false;
    }

    Future<void> showConfirmCancelDialog(Block block) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cancel Booking'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to cancel this booking?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  context.pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  ref
                      .read(bookingsControllerProvider.notifier)
                      .cancel(block, block.origin.businessId)
                      .whenComplete(
                        () => showToast('Sucessully cancelled booking'),
                      );
                  context.pop();
                },
              ),
            ],
          );
        },
      );
    }

    final isBooked = checkStatus(BookingStatus.booked.name);
    final isCancelled = checkStatus(BookingStatus.cancelled.name);
    final isWaitlisted = checkStatus(BookingStatus.waitlisted.name);
    final hasAttended = checkStatus(BookingStatus.attended.name);

    if (isBooked) {
      buttonLabel = ButtonLabel.cancel;
    } else if (hasAttended) {
      buttonLabel = ButtonLabel.review;
    } else if (isWaitlisted) {
      buttonLabel = ButtonLabel.waitlisted;
    } else if (isCancelled) {
      buttonLabel = ButtonLabel.rebook;
    } else {
      buttonLabel = ButtonLabel.book;
    }

    if (isMobileView) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(
          builder: (context) {
            switch (buttonLabel) {
              case ButtonLabel.cancel:
                return CancelButtonWidget(
                  callback: () => showConfirmCancelDialog(block),
                );
              case ButtonLabel.review:
                return ReviewButtonWidget();
              case ButtonLabel.waitlisted:
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    enableFeedback: false,
                    surfaceTintColor: null,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    enabledMouseCursor: SystemMouseCursors.basic,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(buttonLabel),
                );
              default:
                return ElevatedButton(
                  onPressed: () {
                    if (!isBooked) {
                      context.goNamed(
                        ClienteleRoute.bookingDetail.name,
                        pathParameters: {
                          'businessId': block.origin.businessId.toString(),
                          'blockId': block.blockId.toString(),
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.violetC2,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      );
    } else {
      return Align(
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
                      callback: () => showConfirmCancelDialog(block),
                    );
                  case ButtonLabel.waitlisted:
                    return ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        enableFeedback: false,
                        surfaceTintColor: null,
                        overlayColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        enabledMouseCursor: SystemMouseCursors.basic,
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
                  default:
                    return ElevatedButton(
                      onPressed: () {
                        if (!isBooked) {}
                        context.goNamed(
                          ClienteleRoute.bookingDetail.name,
                          pathParameters: {
                            'businessId': block.origin.businessId.toString(),
                            'blockId': block.blockId.toString(),
                          },
                        );
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
        ),
      );
    }
  }
}
