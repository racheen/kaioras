import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/mock_data.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/memberships_screen.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/bookings_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/utils/date_time_utils.dart';

class MembershipListItem extends ConsumerStatefulWidget {
  final List<ExpansionItem> memberships;

  const MembershipListItem({super.key, required this.memberships});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MembershipListItemState();
}

class _MembershipListItemState extends ConsumerState<MembershipListItem> {
  List<ExpansionItem> data = [];

  @override
  void initState() {
    super.initState();

    if (widget.memberships.isNotEmpty) {
      setState(() {
        data = widget.memberships;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncValueMembershipBookings = ref.watch(bookingsControllerProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 600;

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((ExpansionItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/avatar_placeholder.jpg'),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${daysBetweenfromToday(item.membershipItem.expiration)} Days',
                  ),
                  Text(isMobileView ? '' : item.membershipItem.name),
                  Text('with ${item.membershipItem.businessDetails.name}'),
                  Text(
                    item.membershipItem.status,
                    style: TextStyle(
                      color:
                          item.membershipItem.status ==
                              MembershipStatus.active.name
                          ? AppColors.green92
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            );
          },
          body: AsyncValueWidget(
            value: asyncValueMembershipBookings,
            data: (membershipBookings) => Column(
              children: membershipBookings.isEmpty
                  ? [
                      ListTile(
                        tileColor: Colors.grey.shade300,
                        title: Text('No Bookings'),
                      ),
                    ]
                  : membershipBookings
                        .where(
                          (booking) =>
                              booking.membershipId ==
                              item.membershipItem.membershipId,
                        )
                        .map(
                          (booking) => ListTile(
                            title: Text(
                              booking.blockSnapshot!.title.toString(),
                            ),
                            trailing: Text(booking.bookedAt.toString()),
                          ),
                        )
                        .toList(),
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
