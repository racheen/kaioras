import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_business.dart'
    hide AppBusiness;
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/domain/app_business.dart';
import 'package:go_router/go_router.dart';
import '../data/fake_business_repository.dart';
import '../domain/app_business.dart' hide AppBusiness;

class BusinessProfilePage extends ConsumerWidget {
  const BusinessProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessAsyncValue = ref.watch(businessProvider('business001'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => context.push('/edit-business-profile'),
          ),
        ],
      ),
      body: businessAsyncValue.when(
        data: (business) => _BusinessProfileContent(business: business),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _BusinessProfileContent extends StatelessWidget {
  final AppBusiness business;

  const _BusinessProfileContent({Key? key, required this.business})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(business.meta.branding!.logoUrl),
              ),
            ),
            SizedBox(height: 24),
            _buildInfoSection('Business Name', business.name),
            _buildInfoSection('Industry', business.meta.industry),
            _buildInfoSection('Plan', business.plan),
            _buildInfoSection('Created At', business.createdAt.toString()),
            SizedBox(height: 24),
            Text('Offers', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            ...business.offers.map((offer) => _buildOfferCard(offer)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(offer.name, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Type: ${offer.type}'),
            Text('Price: \${(offer.price / 100).toStringAsFixed(2)}'),
            Text('Duration: ${offer.durationInDays} days'),
            Text('Description: ${offer.description}'),
          ],
        ),
      ),
    );
  }
}
