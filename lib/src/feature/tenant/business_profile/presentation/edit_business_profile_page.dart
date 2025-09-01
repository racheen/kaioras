import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_business.dart';
import '../../../../constants/app_colors.dart';
import '../data/fake_business_repository.dart';
import '../domain/app_business.dart' hide AppBusiness;

class EditBusinessProfilePage extends ConsumerStatefulWidget {
  const EditBusinessProfilePage({super.key});

  @override
  _EditBusinessProfilePageState createState() =>
      _EditBusinessProfilePageState();
}

class _EditBusinessProfilePageState
    extends ConsumerState<EditBusinessProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _industryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _industryController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final businessAsyncValue = ref.watch(businessProvider('business001'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Business Profile'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text('Save'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: businessAsyncValue.when(
        data: (business) {
          _nameController.text = business.name;
          _industryController.text = business.meta.industry;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Business Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a business name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _industryController,
                      decoration: InputDecoration(labelText: 'Industry'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an industry';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Offers',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    ...business.offers.map((offer) => _buildOfferCard(offer)),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final businessAsyncValue = ref.read(businessProvider('business001'));
      if (businessAsyncValue is AsyncData<AppBusiness>) {
        final updatedBusiness = businessAsyncValue.value?.copyWith(
          name: _nameController.text,
          industry: _industryController.text,
        );

        ref
            .read(businessRepositoryProvider)
            .updateBusiness(updatedBusiness)
            .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Business profile updated successfully'),
                ),
              );
              Navigator.pop(context);
            })
            .catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update business profile: $error'),
                ),
              );
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update business profile: Business data not available',
            ),
          ),
        );
      }
    }
  }
}
