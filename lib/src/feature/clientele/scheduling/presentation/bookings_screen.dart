import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_app_user_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/data/fake_memberships_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_notifier.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/m_bookings_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

class ExpansionItem {
  ExpansionItem({this.isExpanded = false});

  bool isExpanded;
}

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  bool bookNowIsExpanded = true;
  bool upcomingBookingsIsExpanded = true;
  bool pastBookingsIsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 600;

    final membershipsAsyncValue = ref.watch(membershipsListFutureProvider);
    final upcomingBookingsAsyncValue = ref.watch(
      upcomingBookingsListFutureProvider,
    );
    final pastBookingsAsyncValue = ref.watch(pastBookingsListFutureProvider);

    if (isMobileView) {
      return MBookingsScreen();
    } else {
      return Scaffold(
        body: AsyncValueWidget(
          value: membershipsAsyncValue,
          data: (memberships) => SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(50.0),
              width: 1080,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Bookings',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: AppColors.lightGrey),
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          bookNowIsExpanded = isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(
                                    'Book Now',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              },
                          body: Column(
                            children: memberships.map((membership) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: BoxBorder.fromLTRB(
                                    top: BorderSide(color: AppColors.lightGrey),
                                  ),
                                ),
                                child: ListTile(
                                  minTileHeight: 60,
                                  leading: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      'assets/avatar_placeholder2.jpg',
                                    ),
                                  ),
                                  title: Text(
                                    membership.name.toString(),
                                    style: TextStyle(color: AppColors.violet99),
                                  ),
                                  onTap: () {
                                    if (membership.businessId != null) {
                                      // todo: implement different approach for displaying name
                                      ref
                                          .read(activeBusinessProvider.notifier)
                                          .setActiveBusiness(membership.name!);

                                      context.goNamed(
                                        ClienteleRoute.tenantCalendar.name,
                                        pathParameters: {
                                          'businessId': membership.businessId
                                              .toString(),
                                        },
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          isExpanded: bookNowIsExpanded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  AsyncValueWidget(
                    value: upcomingBookingsAsyncValue,
                    data: (bookings) => Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            upcomingBookingsIsExpanded = isExpanded;
                          });
                        },
                        children: <ExpansionPanel>[
                          ExpansionPanel(
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                                  return ListTile(
                                    title: Text(
                                      'Upcoming',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                },
                            body: Column(
                              children: bookings.map((booking) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: BoxBorder.fromLTRB(
                                      top: BorderSide(
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      booking.title.toString(),
                                      style: TextStyle(
                                        color: AppColors.violet99,
                                      ),
                                    ),
                                    subtitle: Text('Hosted by Business'),
                                    trailing: Text(
                                      booking.startTime.toString(),
                                      style: TextStyle(
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                    onTap: () {
                                      context.goNamed(
                                        ClienteleRoute.bookingDetail.name,
                                        pathParameters: {
                                          'blockId': booking.blockId.toString(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            isExpanded: upcomingBookingsIsExpanded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  AsyncValueWidget(
                    value: pastBookingsAsyncValue,
                    data: (bookings) => Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(color: AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: ExpansionPanelList(
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            pastBookingsIsExpanded = isExpanded;
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
                              children: bookings.map((booking) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: BoxBorder.fromLTRB(
                                      top: BorderSide(
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      booking.title.toString(),
                                      style: TextStyle(
                                        color: AppColors.violet99,
                                      ),
                                    ),
                                    subtitle: Text('Hosted by Business'),
                                    trailing: Text(
                                      booking.startTime.toString(),
                                      style: TextStyle(
                                        color: AppColors.lightGrey,
                                      ),
                                    ),
                                    onTap: () {
                                      context.goNamed(
                                        ClienteleRoute.bookingDetail.name,
                                        pathParameters: {
                                          'blockId': booking.blockId.toString(),
                                        },
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                            isExpanded: pastBookingsIsExpanded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
