import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/tenant/scheduling/domain/app_user.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class UserSignUp extends ConsumerStatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends ConsumerState<UserSignUp> {
  final double _minWidth = 400.0;
  final signUpFormKey = GlobalKey<FormBuilderState>();
  final _businessInfoFormKey = GlobalKey<FormBuilderState>();
  final _accountDetailsFormKey = GlobalKey<FormBuilderState>();
  final _confirmationFormKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _formData = {};
  bool _isHovering = false;

  bool _isCustomer = true;
  bool _showSignUpForm = false;

  // Tenant Sign up form variables
  int _currentStep = 0;
  final int _totalSteps = 3;

  final List<String> _tenantSignUpSteps = [
    'Business Info',
    'Account Details',
    'Confirmation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _showSignUpForm
                    ? _buildSignUpForm()
                    : _buildChoiceScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sign Up for Free',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Choose which type of account you\'d like to create:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 40),
        _buildChoiceButton(
          title: 'Customer',
          description: 'I\'m looking to book classes and/or appointments.',
          isCustomer: true,
        ),
        SizedBox(height: 20),
        _buildChoiceButton(
          title: 'Tenant',
          description: 'I\'m looking to use Kaioras to run my business.',
          isCustomer: false,
        ),
        SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(_minWidth, 60),
            backgroundColor: AppColors.violetE3,
            foregroundColor: AppColors.white,
          ),
          onPressed: () {
            setState(() {
              _showSignUpForm = true;
            });
          },
          child: Text('Sign up as a ${_isCustomer ? 'Customer' : 'Tenant'}'),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account? '),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: GestureDetector(
                    onTap: () => context.goNamed(AppRoute.signIn.name),
                    child: Text(
                      'Log in here',
                      style: TextStyle(
                        color: AppColors.violetE3,
                        decoration: _isHovering
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChoiceButton({
    required String title,
    required String description,
    required bool isCustomer,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isCustomer = isCustomer;
        });
      },
      child: Container(
        width: _minWidth,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isCustomer == isCustomer ? AppColors.violetE3 : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Center(
            child: Text(
              'Sign up',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              _isCustomer
                  ? 'Welcome to Kaioras!'
                  : 'We can\'t wait to be part of your journey!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 30),
          FormBuilder(
            key: signUpFormKey,
            child: _isCustomer
                ? _buildCustomerSignUpForm()
                : _buildTenantSignUpForm(),
          ),
          SizedBox(height: 20),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: Colors.grey[600]),
                children: [
                  TextSpan(text: 'By clicking Sign up you agree to our '),
                  TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(color: AppColors.violetE3),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Terms of Use tap
                      },
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy policy',
                    style: TextStyle(color: AppColors.violetE3),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Privacy policy tap
                      },
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('First name', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField('firstName', 'John'),
        SizedBox(height: 20),
        Text('Last name', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField('lastName', 'Smith'),
        SizedBox(height: 20),
        Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField(
          'email',
          'mail@example.com',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Icon(Icons.info_outline, size: 16, color: Colors.grey),
          ],
        ),
        SizedBox(height: 5),
        _buildTextField(
          'password',
          'Enter your password',
          obscureText: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(8),
          ]),
        ),
        SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.violetE3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _signUp,
            child: Text('Sign up', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildTenantSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: (_currentStep + 1) / _totalSteps,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.violetE3),
        ),
        SizedBox(height: 30),
        FormBuilder(
          key: _getCurrentFormKey(),
          child: _buildCurrentTenantStep(),
        ),
        SizedBox(height: 30),
        _buildTenantNavigationButtons(),
        SizedBox(height: 20),
        Center(
          child: Text(
            'No credit card required',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  GlobalKey<FormBuilderState> _getCurrentFormKey() {
    switch (_currentStep) {
      case 0:
        return _businessInfoFormKey;
      case 1:
        return _accountDetailsFormKey;
      case 2:
        return _confirmationFormKey;
      default:
        return GlobalKey<FormBuilderState>();
    }
  }

  Widget _buildCurrentTenantStep() {
    switch (_currentStep) {
      case 0:
        return _buildBusinessInfoStep();
      case 1:
        return _buildAccountDetailsStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return Container();
    }
  }

  Widget _buildBusinessInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Business name', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField('businessName', 'Rocket Rides'),
        SizedBox(height: 20),
        Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField(
          'email',
          'mail@example.com',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ]),
        ),
      ],
    );
  }

  Widget _buildAccountDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('First name', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField('firstName', 'John'),
        SizedBox(height: 20),
        Text('Last name', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        _buildTextField('lastName', 'Smith'),
        SizedBox(height: 20),
        Row(
          children: [
            Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Icon(Icons.info_outline, size: 16, color: Colors.grey),
          ],
        ),
        SizedBox(height: 5),
        _buildTextField(
          'password',
          'Enter your password',
          obscureText: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(8),
          ]),
        ),
      ],
    );
  }

  Widget _buildConfirmationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Please review your information:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text('Business Name: ${_formData['businessName'] ?? 'N/A'}'),
        Text('Email: ${_formData['email'] ?? 'N/A'}'),
        Text(
          'Name: ${_formData['firstName'] ?? 'N/A'} ${_formData['lastName'] ?? 'N/A'}',
        ),
      ],
    );
  }

  Widget _buildTenantNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep--;
                });
              },
              child: Text('Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                minimumSize: Size(0, 50), // Set a minimum height
              ),
            ),
          ),
        if (_currentStep > 0)
          SizedBox(width: 16), // Add some space between the buttons
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_getCurrentFormKey().currentState?.saveAndValidate() ??
                  false) {
                // Save the current step's form data
                _formData.addAll(_getCurrentFormKey().currentState!.value);

                if (_currentStep < _totalSteps - 1) {
                  setState(() {
                    _currentStep++;
                  });
                } else {
                  _signUp();
                }
              }
            },
            child: Text(_currentStep == _totalSteps - 1 ? 'Sign up' : 'Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.violetE3,
              foregroundColor: Colors.white,
              minimumSize: Size(0, 50), // Set a minimum height
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String name,
    String hintText, {
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.violetE3),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator ?? FormBuilderValidators.required(),
    );
  }

  void _signUp() async {
    print("_signUp method called");

    if (_isCustomer) {
      final formState = signUpFormKey.currentState;
      if (formState != null && formState.saveAndValidate()) {
        _formData = formState.value;
        _processCustomerSignUp();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields correctly')),
        );
      }
    } else {
      final formKey = _getCurrentFormKey();
      print("Current form key: $formKey");

      final formState = formKey.currentState;
      print("Form state: $formState");

      if (formState == null) {
        print('Form state is null. This might be because:');
        print('1. The form has not been built yet.');
        print(
          '2. The form key is not properly attached to a FormBuilder widget.',
        );
        print('3. The form is not currently in the widget tree.');

        if (_currentStep == _totalSteps - 1) {
          print(
            'Attempting to use accumulated form data for tenant sign up...',
          );
          _processTenantSignUp();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred. Please try again.')),
          );
        }
        return;
      }

      final isValid = formState.saveAndValidate();
      print("Form is valid: $isValid");

      if (isValid) {
        print('Form validation passed. Proceeding with sign up...');
        _formData.addAll(formState.value);
        if (_currentStep < _totalSteps - 1) {
          setState(() {
            _currentStep++;
          });
        } else {
          _processTenantSignUp();
        }
      } else {
        print('Form validation failed. Errors: ${formState.errors}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields correctly')),
        );
      }
    }
  }

  void _processCustomerSignUp() async {
    final userData = {
      'name': '${_formData['firstName']} ${_formData['lastName']}',
      'email': _formData['email'],
      'password': _formData['password'],
      'isCustomer': true,
    };

    try {
      final newUser = await ref
          .read(authServiceProvider)
          .signUpUser(userData, 'business001');
      print('New user: $newUser');
      if (newUser != null && newUser is AppUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful! User ID: ${newUser.uid}')),
        );
        // Navigate to the home screen or next step
        context.goNamed(AppRoute.home.name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: User not created')),
        );
      }
    } catch (e) {
      print('Error during customer signup: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    }
  }

  void _processTenantSignUp() async {
    final userData = {
      'name': '${_formData['firstName']} ${_formData['lastName']}',
      'email': _formData['email'],
      'password': _formData['password'],
      'isCustomer': false,
    };

    final businessData = {
      'businessName': _formData['businessName'],
      // Add other business-related fields as needed
    };

    try {
      final newUser = await ref
          .read(authServiceProvider)
          .signUpTenant(userData, businessData);
      print('New tenant user: $newUser');
      if (newUser != null && newUser is AppUser) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tenant signup successful! User ID: ${newUser.uid}'),
          ),
        );
        // Navigate to the home screen or next step
        context.goNamed(AppRoute.home.name);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tenant signup failed: User not created or invalid type',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error during tenant signup: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tenant signup failed: $e')));
    }
  }
}
