import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class TenantSignUp extends ConsumerWidget {
  const TenantSignUp({Key? key}) : super(key: key);

  final double _minWidth = 400.0;
  final double _runSpacing = 20.0;
  final double _spacing = 20.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpFormKey = GlobalKey<FormBuilderState>();

    void backToSignIn() {
      print('Back to Sign In');
      context.goNamed(AppRoute.signIn.name);
    }

    void signUp() async {
      if (signUpFormKey.currentState?.saveAndValidate() ?? false) {
        final formData = signUpFormKey.currentState!.value;

        final userData = {
          'name': formData['name'],
          'email': formData['email'],
          'password': formData['password'],
          // password is typically not stored in Firestore
        };

        final businessData = {
          'businessName': formData['businessName'],
          'industry': formData['industry'],
          'primaryColor': formData['primaryColor'],
          'logoUrl': formData['logoUrl'],
        };

        try {
          await ref
              .read(authServiceProvider)
              .signUpTenant(userData, businessData);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Signup successful!')));
          // TODO: Navigate to home screen or next step
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
        }
      }
    }

    Widget _buildTextField(
      String name,
      String label, {
      bool obscureText = false,
      String? Function(String?)? validator,
    }) {
      return SizedBox(
        width: _minWidth,
        child: FormBuilderTextField(
          name: name,
          decoration: InputDecoration(labelText: label),
          obscureText: obscureText,
          validator: validator ?? FormBuilderValidators.required(),
        ),
      );
    }

    Widget _buildFormButtons() {
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
                onPressed: backToSignIn,
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
                onPressed: signUp,
                child: const Text('Sign Up'),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tenant Sign Up')),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                  key: signUpFormKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          runSpacing: _runSpacing,
                          spacing: _spacing,
                          children: [
                            _buildTextField('name', 'Full Name'),
                            _buildTextField(
                              'email',
                              'Email',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            _buildTextField(
                              'password',
                              'Password',
                              obscureText: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(8),
                              ]),
                            ),
                            _buildTextField(
                              'confirmPassword',
                              'Confirm Password',
                              obscureText: true,
                              validator: (val) {
                                if (val !=
                                    signUpFormKey
                                        .currentState
                                        ?.fields['password']
                                        ?.value) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const Divider(
                              color: AppColors.lightGrey,
                              thickness: 1.0,
                            ),
                            Text(
                              'Business Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildTextField('businessName', 'Business Name'),
                            _buildTextField('industry', 'Industry'),
                            _buildTextField('primaryColor', 'Primary Color'),
                            _buildTextField(
                              'logoUrl',
                              'Logo URL',
                              validator: FormBuilderValidators.url(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFormButtons(),
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
