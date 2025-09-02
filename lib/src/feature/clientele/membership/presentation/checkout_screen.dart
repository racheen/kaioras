import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/scheduling/presentation/block_list/business_notifier.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String businessId;

  const CheckoutScreen({super.key, required this.businessId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final businessName = ref.watch(activeBusinessProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(40.0),
          width: 1080,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   'Checkout',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              // ),
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/avatar_placeholder2.jpg'),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(businessName ?? ''),
              ),
              SizedBox(height: 40),
              Container(
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
                        'Offer name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Description', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      Divider(),
                      Text(
                        'Purchase Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          overlayColor: Colors.transparent,

                          backgroundColor: AppColors.violetC2,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text('Purchase'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
