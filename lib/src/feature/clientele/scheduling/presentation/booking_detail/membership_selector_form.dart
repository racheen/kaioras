import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final _bookingFormKey = GlobalKey<FormBuilderState>();

class MembershipSelectorForm extends ConsumerStatefulWidget {
  final List<FormBuilderFieldOption<String>> memberships;

  final Function callback;

  const MembershipSelectorForm({
    super.key,
    required this.memberships,
    required this.callback,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MembershipSelectorFormState();
}

class _MembershipSelectorFormState
    extends ConsumerState<MembershipSelectorForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FormBuilder(
          key: _bookingFormKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FormBuilderRadioGroup(
                name: 'membership',
                decoration: InputDecoration(
                  labelText: 'Select membership to use',
                  border: const OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(
                  errorText: 'You need to select a membership to proceed',
                ),
                options: widget.memberships,
              ),
            ),
          ),
        ),
        SizedBox(height: 100),
        ElevatedButton(
          onPressed: () {
            if (_bookingFormKey.currentState?.saveAndValidate() ?? false) {
              final membershipId =
                  _bookingFormKey.currentState!.value['membership'];
              widget.callback(membershipId);
            }
          },
          style: ElevatedButton.styleFrom(
            overlayColor: Colors.transparent,

            backgroundColor: AppColors.violetC2,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text('Book with membership'),
        ),
      ],
    );
  }
}
