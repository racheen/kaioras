import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

class OffersListItem extends ConsumerWidget {
  final String name;
  final String image;
  final String description;
  final String price;
  final String credits;
  final String type;

  const OffersListItem({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.credits,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      width: 400,
      height: 250,
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListTile(
            minTileHeight: 60,
            title: Text(name),
            leading: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/avatar_placeholder2.jpg'),
            ),
          ),
          Divider(),
          Text(description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('$credits credits'), Text(type)],
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.goNamed(
                ClienteleRoute.checkout.name,
                pathParameters: {
                  'businessId': 'business001',
                }, // todo: replace with actual businessId
              );
            },
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: AppColors.violetC2,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Buy'),
          ),
        ],
      ),
    );
  }
}
