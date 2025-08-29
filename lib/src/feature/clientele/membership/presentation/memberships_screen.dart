import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/common/async_value_widget.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/membership_list_item.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/memberships_controller.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';

class ExpansionItem {
  ExpansionItem({
    required this.membershipItem,
    this.isExpanded = false,
    this.isActive = false,
  });

  Membership membershipItem;
  bool isExpanded;
  bool isActive;
}

List<ExpansionItem> generateExpansionItems(
  List<Membership> memberships,
  bool isExpanded,
) {
  return List<ExpansionItem>.generate(memberships.length, (int index) {
    return ExpansionItem(
      membershipItem: memberships[index],
      isExpanded: isExpanded,
      isActive: true,
    );
  });
}

class MembershipsScreen extends ConsumerStatefulWidget {
  const MembershipsScreen({super.key});

  @override
  ConsumerState<MembershipsScreen> createState() => _MembershipsScreenState();
}

class _MembershipsScreenState extends ConsumerState<MembershipsScreen> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final asyncMemberships = ref.watch(membershipsControllerProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          width: 1080,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Memberships',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        side: BorderSide(color: AppColors.violetE3),
                      ),
                      child: Text('Active'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      side: BorderSide(color: AppColors.violetE3),
                    ),
                    child: Text('New'),
                  ),
                ],
              ),
              AsyncValueWidget(
                value: asyncMemberships,
                data: (memberships) {
                  final data = generateExpansionItems(memberships, isExpanded);

                  return MembershipListItem(memberships: data);
                },
              ),
            ],
            // ),
          ),
        ),
      ),
    );
  }
}
