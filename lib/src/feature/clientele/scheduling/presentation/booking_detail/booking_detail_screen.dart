import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod_boilerplate/src/common/global_loading_indicator.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/memberships_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/application/booking_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_notifier.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/booking_detail/membership_selector_form.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_detail/block_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/utils/toast.dart';
import 'package:go_router/go_router.dart';

List<Membership> filterMemberships(List<Membership> memberships, Block block) {
  return memberships.where((membership) {
    final hasActiveMembership = membership.status == 'active';
    final isValidType = membership.offerSnapshot.blockType == block.type;
    final hasValidSubtype = block.subtype!.contains(
      membership.offerSnapshot.blockSubtype,
    );
    final hasCredits = membership.credits > 0;

    return hasActiveMembership && isValidType && hasValidSubtype && hasCredits;
  }).toList();
}

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String blockId;
  final String businessId;

  const BookingDetailScreen({
    super.key,
    required this.blockId,
    required this.businessId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final blockAsyncValue = ref.watch(blockControllerProvider(widget.blockId));
    final userMembershipsAsyncValue = ref.watch(membershipsControllerProvider);
    final businessName = ref.watch(activeBusinessProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 600;

    Future<void> showConfirmWaitlistDialog(
      businessId,
      block,
      membershipId,
    ) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('There are no more available slots'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Do you wish to be added as waitlisted?'),
                  Text(
                    'We can let you know when slots opened up for this booking.',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  context.pop();
                  context.goNamed(ClienteleRoute.clienteleBookings.name);
                },
              ),
              TextButton(
                child: const Text('Yes', style: TextStyle(color: Colors.green)),
                onPressed: () async {
                  ref.read(loadingProvider.notifier).state = true;
                  final isComplete = await ref
                      .read(bookingsServiceProvider)
                      .waitlist(businessId, block, membershipId);

                  if (context.mounted && isComplete) {
                    context.pop();
                    context.goNamed(ClienteleRoute.clienteleBookings.name);
                    ref.read(loadingProvider.notifier).state = false;
                    showGlobalToast(ref, 'Successfully added as waitlist');
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(20.0),
        width: 1080,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/avatar_placeholder2.jpg'),
                backgroundColor: Colors.transparent,
              ),
              title: Text(businessName ?? ''),
            ),
            SizedBox(height: 40),
            AsyncValueWidget(
              value: blockAsyncValue,
              data: (block) {
                if (block == null) {
                  context.pop();
                } else {
                  return Container(
                    width: 540,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            block.title.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Description', style: TextStyle(fontSize: 16)),
                          Text(
                            block.description.toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start time: ${block.startTime.toString()}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Duration: ${block.duration.toString()} minutes',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Location: ${block.location.toString()}',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 16),
                          AsyncValueWidget(
                            value: userMembershipsAsyncValue,
                            data: (memberships) {
                              final filteredMemberships = filterMemberships(
                                memberships,
                                block,
                              );
                              final validMemberships = filteredMemberships
                                  .map(
                                    (membership) => FormBuilderFieldOption(
                                      value: membership.membershipId,
                                      child: ListTile(
                                        title: Text(membership.name),
                                      ),
                                    ),
                                  )
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: validMemberships.isEmpty,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            'You have no valid membership to use',
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.goNamed(
                                                ClienteleRoute
                                                    .clienteleOffers
                                                    .name,
                                              );
                                            },
                                            child: Text('Browse Offers'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: validMemberships.isNotEmpty,
                                    child: MembershipSelectorForm(
                                      memberships: validMemberships,
                                      callback: (membershipId) async {
                                        // todo: implement membership check before allowing to book a block

                                        final hasAvailability = await ref
                                            .read(bookingsServiceProvider)
                                            .checkAvailability(
                                              block.origin.businessId,
                                              block,
                                              membershipId,
                                            );
                                        if (hasAvailability) {
                                          ref
                                              .read(
                                                bookingsControllerProvider
                                                    .notifier,
                                              )
                                              .book(
                                                businessId:
                                                    block.origin.businessId,
                                                block: block,
                                                membershipId: membershipId,
                                              )
                                              .whenComplete(() {
                                                if (context.mounted) {
                                                  context.goNamed(
                                                    ClienteleRoute
                                                        .clienteleBookings
                                                        .name,
                                                  );
                                                  showGlobalToast(
                                                    ref,
                                                    'Successfully booked',
                                                  );
                                                }
                                              });
                                        } else {
                                          showConfirmWaitlistDialog(
                                            block.origin.businessId,
                                            block,
                                            membershipId,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
