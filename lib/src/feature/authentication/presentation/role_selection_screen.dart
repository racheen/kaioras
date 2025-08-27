import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/clientele/clientele_router.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoute.schedule.name),
              child: Text('Continue as Tenant'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.goNamed(ClienteleRoute.clienteleBookings.name),
              child: Text('Continue as Client'),
            ),
          ],
        ),
      ),
    );
  }
}
