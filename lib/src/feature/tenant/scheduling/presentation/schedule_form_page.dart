import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/business_profile/data/firebase_business_repostiory.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/data/blocks_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/availability.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/block.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/presentation/custom_date_time_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

List<String> typeOptions = ['Private', 'Group'];
List<String> subtypeOptions = ['Reformer', 'Mat', 'Chair'];
List<String> visibilityOptions = ['Public', 'Private'];
List<String> locationOptions = ['Studio A', 'Studio B'];

class ScheduleForm extends ConsumerStatefulWidget {
  final List<Block> existingBlocks;

  const ScheduleForm({super.key, required this.existingBlocks});

  @override
  ConsumerState<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends ConsumerState<ScheduleForm> {
  final _createClassKey = GlobalKey<FormBuilderState>();
  AsyncValue<AppUser?> currentUserAsync = const AsyncValue.loading();
  late List<Block> existingBlocks;

  @override
  void initState() {
    super.initState();
    existingBlocks = widget.existingBlocks;
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    currentUserAsync = ref.read(currentAppUserProvider);
    currentUserAsync.whenData((user) {
      if (user != null) {
        setState(() {});
      }
    });
  }

  final double _minWidth = 400.0;
  final double _spacing = 120.0;
  final double _runSpacing = 10.0;
  final String formTitle = 'Create New Schedule';

  void cancelForm() {
    debugPrint('Form cancelled');
  }

  Future<void> submitForm(BuildContext context) async {
    if (_createClassKey.currentState?.saveAndValidate() ?? false) {
      final formData = _createClassKey.currentState!.value;
      final startTime = formData['startTime'] as DateTime;

      final currentUser = currentUserAsync.value;
      if (currentUser == null || currentUser.roles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not available')),
        );
        return;
      }

      final businessId = currentUser.roles.keys.firstOrNull;
      if (businessId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No business associated with this account'),
          ),
        );
        return;
      }

      final Block newBlock = Block(
        blockId: '',
        title: formData['title'],
        type: formData['type'],
        subtype: formData['subtype'],
        startTime: startTime,
        duration: int.parse(formData['duration']),
        location: formData['location'],
        capacity: int.parse(formData['capacity']),
        visibility: formData['visibility'],
        status: 'active',
        createdAt: DateTime.now().toString(),
        tags:
            (formData['tags'] as String?)
                ?.split(',')
                .map((e) => e.trim())
                .toList() ??
            [],
        description: formData['description'] ?? '',
        host: Host(
          uid: currentUser.uid,
          name: currentUser.name,
          title: 'Onwer',
          about: 'Test User',
          image: 'https://example.com/stretch_instructor.jpg',
        ),
        origin: Origin(businessId: businessId, name: 'Pilates', image: ''),
      );

      try {
        await ref
            .read(blocksRepositoryProvider)
            .createNewBlock(newBlock, businessId);
        debugPrint('New Block: $newBlock');
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
  Widget build(BuildContext context) {
    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null || currentUser.roles.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create New Schedule')),
            body: Center(child: Text('No user data available')),
          );
        }

        final businessId = currentUser.roles.keys.firstOrNull;
        if (businessId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create New Schedule')),
            body: Center(
              child: Text('No business associated with this account'),
            ),
          );
        }

        final businessAvailabilityAsync = ref.watch(
          businessAvailabilityProvider(businessId),
        );

        return Scaffold(
          appBar: AppBar(title: const Text('Create New Schedule')),
          body: businessAvailabilityAsync.when(
            data: (businessAvailability) {
              return businessAvailability != null
                  ? _buildForm(context, businessAvailability)
                  : Center(child: Text('No availability data'));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
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
                List<TimeRange> existingTimeRanges = existingBlocks.map((
                  block,
                ) {
                  return TimeRange(
                    start: TimeOfDay.fromDateTime(block.startTime!),
                    end: TimeOfDay.fromDateTime(
                      block.startTime!.add(Duration(minutes: block.duration!)),
                    ),
                  );
                }).toList();

                final DateTime? picked = await showCustomDateTimePicker(
                  context: context,
                  initialDate: field.value ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  studioAvailability: studioAvailability,
                  existingBlocks: existingTimeRanges,
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

  Widget _buildFormButtons(BuildContext context) {
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
              onPressed: () => submitForm(context),
              child: const Text('Create Schedule'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, Availability businessAvailability) {
    return Center(
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
                          _buildDropdown('subtype', 'SubType', subtypeOptions),
                          _buildTextField('tags', 'Tags (comma-separated)'),
                          _buildTextField(
                            'description',
                            'Description',
                            maxLines: 3,
                          ),
                          const Divider(
                            color: AppColors.lightGrey,
                            thickness: 1.0,
                          ),
                          _buildDateTimePicker(context, businessAvailability),
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
                    _buildFormButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
