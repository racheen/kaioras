import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    required this.description,
    required this.business,
    this.isExpanded = false,
    this.isActive = false,
  });

  String expandedValue;
  String headerValue;
  String description;
  String business;
  bool isExpanded;
  bool isActive;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Duration',
      description: 'Description',
      business: 'with Business $index',
      expandedValue: 'This is item number $index',
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
  final List<Item> data = generateItems(8);

  @override
  Widget build(BuildContext context) {
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
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    data[index].isExpanded = isExpanded;
                  });
                },
                children: data.map<ExpansionPanel>((Item item) {
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
                            Text(isMobileView ? '' : item.headerValue),
                            Text(isMobileView ? '' : item.description),
                            Text(item.business),
                            item.isActive
                                ? Text(
                                    'Active',
                                    style: TextStyle(color: AppColors.green92),
                                  )
                                : Text(
                                    'Inactive',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                          ],
                        ),
                      );
                    },
                    body: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.grey.shade300,
                          title: Text('Details'),
                          trailing: Text('07/27/2025, 10:38 PM'),
                          onTap: () {
                            // todo: implement functionality
                          },
                        ),
                      ],
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ],
            // ),
          ),
        ),
      ),
    );
  }
}
