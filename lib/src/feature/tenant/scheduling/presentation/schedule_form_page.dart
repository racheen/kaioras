import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/schedule_repository.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/schedule.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final _createClassKey = GlobalKey<FormBuilderState>();
List<String> typeOptions = ['Individual', 'Group'];
List<String> visibilityOptions = ['Public', 'Private'];
List<String> statusOptions = ['Active', 'Inactive', 'Cancelled'];
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

      final EventModel newEvent = EventModel(
        id: '',
        businessId: 'stretch-n-flow',
        providerId: 'user005', // Or derive dynamically
        title: formData['title'],
        type: formData['type'],
        startTime: Timestamp.fromDate(startTime),
        duration: int.parse(formData['duration']),
        location: formData['location'],
        capacity: int.parse(formData['capacity']),
        visibility: formData['visibility'],
        status: formData['status'],
        createdAt: Timestamp.fromDate(DateTime.now()),
      );

      try {
        await ref.read(eventServiceProvider).create(newEvent);
        debugPrint('✅ Event created!');

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule created successfully')),
        );

        // Navigate back to the schedule page
        Navigator.of(context).pop();
      } catch (e) {
        debugPrint('❌ Error: $e');

        // Show an error message
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
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderTextField(
                                name: 'title',
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderDropdown<String>(
                                name: 'type',
                                decoration: const InputDecoration(
                                  labelText: 'Type',
                                  border: OutlineInputBorder(),
                                ),
                                items: typeOptions
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(type),
                                      ),
                                    )
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderDateTimePicker(
                                name: 'startTime',
                                decoration: const InputDecoration(
                                  labelText: 'Start Time',
                                  border: OutlineInputBorder(),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderTextField(
                                name: 'duration',
                                decoration: const InputDecoration(
                                  labelText: 'Duration (minutes)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderDropdown<String>(
                                name: 'location',
                                decoration: const InputDecoration(
                                  labelText: 'Location',
                                  border: OutlineInputBorder(),
                                ),
                                items: locationOptions
                                    .map(
                                      (location) => DropdownMenuItem(
                                        value: location,
                                        child: Text(location),
                                      ),
                                    )
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderTextField(
                                name: 'capacity',
                                decoration: const InputDecoration(
                                  labelText: 'Capacity',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderDropdown<String>(
                                name: 'visibility',
                                decoration: const InputDecoration(
                                  labelText: 'Visibility',
                                  border: OutlineInputBorder(),
                                ),
                                items: visibilityOptions
                                    .map(
                                      (visibility) => DropdownMenuItem(
                                        value: visibility,
                                        child: Text(visibility),
                                      ),
                                    )
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: _minWidth,
                              child: FormBuilderDropdown<String>(
                                name: 'status',
                                decoration: const InputDecoration(
                                  labelText: 'Status',
                                  border: OutlineInputBorder(),
                                ),
                                items: statusOptions
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ),
                                    )
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
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
                                onPressed: () => submitForm(ref),
                                child: const Text('Create Schedule'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
