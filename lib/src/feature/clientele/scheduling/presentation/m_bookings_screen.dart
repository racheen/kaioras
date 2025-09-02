import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/common/booking_card_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/common/carousel_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_app_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_memberships_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

class MBookingsScreen extends ConsumerStatefulWidget {
  const MBookingsScreen({super.key});

  @override
  ConsumerState<MBookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<MBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    final membershipsAsyncValue = ref.watch(membershipsListFutureProvider);
    final upcomingBookingsAsyncValue = ref.watch(bookingsControllerProvider);
    final pastBookingsAsyncValue = ref.watch(pastBookingsListFutureProvider);

    return AsyncValueWidget(
      value: membershipsAsyncValue,
      data: (memberships) => ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Book Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  child: Row(
                    spacing: 25.0,
                    children: memberships
                        .map(
                          (membership) => MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (membership.businessId != null) {
                                  context.goNamed(
                                    ClienteleRoute.tenantCalendar.name,
                                    pathParameters: {
                                      'businessId': membership.businessId
                                          .toString(),
                                    },
                                  );
                                }
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: AssetImage(
                                      'assets/avatar_placeholder2.jpg',
                                    ),
                                  ),
                                  Text(
                                    membership.name.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Upcoming',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              AsyncValueWidget(
                value: upcomingBookingsAsyncValue,
                data: (booking) => Carousel(
                  children: booking
                      .map(
                        (booking) => GestureDetector(
                          onTap: () {
                            context.goNamed(
                              ClienteleRoute.blockDetail.name,
                              pathParameters: {
                                'blockId': booking.block!.blockId.toString(),
                              },
                            );
                          },
                          child: BookingCardWidget(
                            title: booking.block!.title.toString(),
                            startTime: booking.block!.startTime!,
                            duration: booking.block!.duration!,
                            location: booking.block?.location.toString() ?? '',
                            status: booking.status.toString(),
                            block: booking.block!,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Past Bookings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              AsyncValueWidget(
                value: pastBookingsAsyncValue,
                data: (pastBookings) => Column(
                  children: pastBookings
                      .map(
                        (booking) => GestureDetector(
                          onTap: () {
                            context.goNamed(
                              ClienteleRoute.blockDetail.name,
                              pathParameters: {
                                'blockId': booking.block!.blockId.toString(),
                              },
                            );
                          },
                          child: BookingCardWidget(
                            title: booking.block!.title.toString(),
                            startTime: booking.block!.startTime!,
                            duration: booking.block!.duration!,
                            location:
                                booking.block?.location.toString() ??
                                'no location',
                            status: booking.status.toString(),
                            block: booking.block!,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
