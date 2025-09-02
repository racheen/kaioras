import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_notifier.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_controller.dart';
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

    final userAsyncValue = ref.watch(currentAppUserProvider);
    final bookingsAsyncValue = ref.watch(bookingsControllerProvider);

    return Scaffold(
      body: AsyncValueWidget(
        value: userAsyncValue,
        data: (appUser) {
          List userMemberships = [];
          final userRoleIds = appUser?.roles.keys ?? [];

          if (appUser != null && userRoleIds.isNotEmpty) {
            // todo: need to display business name
            userMemberships = userRoleIds
                .map(
                  (id) => {
                    'businessId': id,
                    'role': appUser.roles[id]?.role,
                    'status': appUser.roles[id]?.status,
                  },
                )
                .where((role) => role['status'] == 'active')
                .where((role) => role['role'] == 'customer')
                .toList();
          }

          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(isMobileView ? 20.0 : 50.0),
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
                            children: userMemberships.isEmpty
                                ? [Text('No current membership')]
                                : userMemberships.map((business) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: BoxBorder.fromLTRB(
                                          top: BorderSide(
                                            color: AppColors.lightGrey,
                                          ),
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
                                          business['businessId'].toString(),
                                          style: TextStyle(
                                            color: AppColors.violet99,
                                          ),
                                        ),
                                        onTap: () {
                                          // todo: implement different approach for displaying name
                                          ref
                                              .read(
                                                activeBusinessProvider.notifier,
                                              )
                                              .setActiveBusiness(
                                                business['businessId']
                                                    .toString(),
                                              );

                                          context.goNamed(
                                            ClienteleRoute.tenantCalendar.name,
                                            pathParameters: {
                                              'businessId':
                                                  business['businessId']
                                                      .toString(),
                                            },
                                          );
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
                    value: bookingsAsyncValue,
                    data: (bookings) {
                      final upcomingBookings = bookings.where(
                        (booking) => booking.blockSnapshot!.startTime.isAfter(
                          DateTime.now(),
                        ),
                      );
                      return Container(
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
                                children: upcomingBookings.isEmpty
                                    ? [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text('No upcoming bookings'),
                                        ),
                                      ]
                                    : upcomingBookings.map((booking) {
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
                                              booking.blockSnapshot!.title
                                                  .toString(),
                                              style: TextStyle(
                                                color: AppColors.violet99,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Hosted by ${booking.blockSnapshot?.origin.name}',
                                            ),
                                            trailing: Text(
                                              booking.blockSnapshot!.startTime
                                                  .toString(),
                                              style: TextStyle(
                                                color: AppColors.lightGrey,
                                              ),
                                            ),
                                            onTap: () {
                                              context.goNamed(
                                                ClienteleRoute.blockDetail.name,
                                                pathParameters: {
                                                  'blockId': booking
                                                      .blockSnapshot!
                                                      .blockId
                                                      .toString(),
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
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  AsyncValueWidget(
                    value: bookingsAsyncValue,
                    data: (bookings) {
                      final pastBookings = bookings.where(
                        (booking) => booking.blockSnapshot!.startTime.isBefore(
                          DateTime.now(),
                        ),
                      );
                      return Container(
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
                                children: pastBookings.isEmpty
                                    ? [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text('No past bookings'),
                                        ),
                                      ]
                                    : pastBookings.map((booking) {
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
                                              booking.blockSnapshot!.title
                                                  .toString(),
                                              style: TextStyle(
                                                color: AppColors.violet99,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Hosted by ${booking.blockSnapshot?.origin.name}',
                                            ),
                                            trailing: Text(
                                              booking.blockSnapshot!.startTime
                                                  .toString(),
                                              style: TextStyle(
                                                color: AppColors.lightGrey,
                                              ),
                                            ),
                                            onTap: () {
                                              context.goNamed(
                                                ClienteleRoute.blockDetail.name,
                                                pathParameters: {
                                                  'blockId': booking
                                                      .block!
                                                      .blockId
                                                      .toString(),
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
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
