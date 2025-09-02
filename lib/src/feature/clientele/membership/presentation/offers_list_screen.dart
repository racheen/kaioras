import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/clientele/membership/presentation/offers_list_item.dart';

class OffersListScreen extends ConsumerStatefulWidget {
  const OffersListScreen({super.key});

  @override
  ConsumerState<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends ConsumerState<OffersListScreen> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(isMobileView ? 10.0 : 40.0),
          width: 1080,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Offers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              // todo: implement ofers list filtering
              SizedBox(height: 40),
              Wrap(
                children: [
                  OffersListItem(
                    name: 'Test Data',
                    image: '',
                    description: '8x Month Reformer',
                    price: '60',
                    credits: '8',
                    type: 'type',
                  ),
                  OffersListItem(
                    name: 'Test Data',
                    image: '',
                    description: '8x Month Reformer',
                    price: '60',
                    credits: '8',
                    type: 'type',
                  ),
                  OffersListItem(
                    name: 'Test Data',
                    image: '',
                    description: '8x Month Reformer',
                    price: '60',
                    credits: '8',
                    type: 'type',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
