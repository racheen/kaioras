import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/firebase_blocks_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/custom_date_time_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

final _createClassKey = GlobalKey<FormBuilderState>();
List<String> typeOptions = ['Individual', 'Group'];
List<String> visibilityOptions = ['Public', 'Private'];
List<String> locationOptions = ['Studio A', 'Studio B'];

class ScheduleForm extends ConsumerWidget {
  const ScheduleForm({super.key});

  final double _minWidth = 400.0;
  final double _spacing = 120.0;
  final double _runSpacing = 10.0;
  final String formTitle = 'Create New Schedule';

  void cancelForm() {
    debugPrint('Form cancelled');
  }

  Future<void> submitForm(BuildContext context, WidgetRef ref) async {
    if (_createClassKey.currentState?.saveAndValidate() ?? false) {
      final formData = _createClassKey.currentState!.value;
      final startTime = formData['startTime'] as DateTime;

      final Block newEvent = Block(
        blockId:
            '', // This will be set by Firestore when the document is created
        businessDetails: BusinessDetails(
          businessId: 'business001',
          name: 'Pialtes Studio',
          picture: 'https://example.com/logo.png',
        ),
        title: formData['title'],
        type: formData['type'],
        startTime: startTime,
        duration: int.parse(formData['duration']),
        location: formData['location'],
        capacity: int.parse(formData['capacity']),
        visibility: formData['visibility'],
        status: 'active', // Assuming new events are always created as active
        createdAt: DateTime.now(),
        tags:
            (formData['tags'] as String?)
                ?.split(',')
                .map((e) => e.trim())
                .toList() ??
            [],
        description: formData['description'] ?? '',
        attendees: {},
        host: Host(
          uid: 'user001',
          name: 'Jane Doe',
          details:
              'Experienced instructor specializing in beginner and intermediate Pilates',
        ),
      );

      try {
        await ref.read(eventServiceProvider).create(newEvent);
        debugPrint('New Blocks: $newEvent');
        debugPrint('✅ Event created!');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule created successfully')),
        );

        Navigator.of(context).pop();
      } catch (e) {
        debugPrint('❌ Error: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating schedule: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      debugPrint('❗Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studioAvailability = ref.watch(studioAvailabilityProvider);

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Create New Schedule'))),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: _createClassKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          runSpacing: _runSpacing,
                          spacing: _spacing,
                          children: [
                            _buildTextField('title', 'Title'),
                            _buildDropdown('type', 'Type', typeOptions),
                            _buildTextField(
                              'description',
                              'Description',
                              maxLines: 3,
                            ),
                            _buildTextField('tags', 'Tags (comma-separated)'),
                            const Divider(
                              color: AppColors.lightGrey,
                              thickness: 1.0,
                            ),
                            _buildDateTimePicker(context, studioAvailability),
                            _buildTextField(
                              'duration',
                              'Duration (minutes)',
                              keyboardType: TextInputType.number,
                            ),
                            _buildDropdown(
                              'location',
                              'Location',
                              locationOptions,
                            ),
                            _buildTextField(
                              'capacity',
                              'Capacity',
                              keyboardType: TextInputType.number,
                            ),
                            _buildDropdown(
                              'visibility',
                              'Visibility',
                              visibilityOptions,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormButtons(context, ref),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String name,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: _minWidth,
      child: FormBuilderTextField(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: maxLines > 1,
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          if (name == 'description') FormBuilderValidators.maxLength(200),
          if (keyboardType == TextInputType.number)
            FormBuilderValidators.numeric(),
        ]),
      ),
    );
  }

  Widget _buildDropdown(String name, String label, List<String> options) {
    return SizedBox(
      width: _minWidth,
      child: FormBuilderDropdown<String>(
        name: name,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    );
  }

  Widget _buildDateTimePicker(
    BuildContext context,
    Availability studioAvailability,
  ) {
    return SizedBox(
      width: _minWidth,
      child: FormBuilderField<DateTime>(
        name: 'startTime',
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        builder: (FormFieldState<DateTime> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Date and Time',
              errorText: field.errorText,
              border: const OutlineInputBorder(),
            ),
            child: ListTile(
              title: Text(
                field.value != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(field.value!)
                    : 'Select Date and Time',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showCustomDateTimePicker(
                  context: context,
                  initialDate: field.value ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  studioAvailability: studioAvailability,
                );
                if (picked != null) {
                  field.didChange(picked);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        runSpacing: _runSpacing,
        spacing: _spacing,
        children: [
          SizedBox(
            width: _minWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(_minWidth, 60),
                backgroundColor: AppColors.whiteSmoke,
                foregroundColor: AppColors.violetE3,
              ),
              onPressed: () => cancelForm(),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(
            width: _minWidth,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(_minWidth, 60),
                backgroundColor: AppColors.violetE3,
                foregroundColor: AppColors.white,
              ),
              onPressed: () => submitForm(context, ref),
              child: const Text('Create Schedule'),
            ),
          ),
        ],
      ),
    );
  }
}
