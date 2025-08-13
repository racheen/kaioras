import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

final _loginFormKey = GlobalKey<FormBuilderState>();
final _emailFieldKey = GlobalKey<FormBuilderState>();

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  final String appName = 'Pilagenda';
  final double _minWidth = 400.0;
  final String _welcomeText = 'Welcome Back~';
  final String _signInText = 'Sign in';
  final String _signUpText = 'Sign up here!';
  final String _forgotPasswordText = 'Forgot your password?';

  @override
  Widget build(BuildContext context) {
    void signUp() {
      debugPrint('Sign up clicked');
    }

    void signIn() {
      debugPrint('Sign in clicked');
      _loginFormKey.currentState?.saveAndValidate();
      debugPrint(_loginFormKey.currentState?.value.toString());

      // can access all field values without saving form with instantValues
      _loginFormKey.currentState?.validate();
      debugPrint(_loginFormKey.currentState?.instantValue.toString());
    }

    void forgotPassword() {
      debugPrint('Forgot password clicked');
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _welcomeText,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40.0),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: _minWidth,
                child: FormBuilder(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: _minWidth,
                        child: FormBuilderTextField(
                          key: _emailFieldKey,
                          name: 'email',
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'password',
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(_minWidth, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () => signIn(),
                        child: Text(_signInText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.0),
            GestureDetector(
              onTap: () => forgotPassword(),
              child: Text(
                _forgotPasswordText,
                style: TextStyle(color: AppColors.violetE3),
              ),
            ),
            SizedBox(width: _minWidth, child: Divider(height: 80.0)),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  'New to $appName? ',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                GestureDetector(
                  onTap: () => signUp(),
                  child: Text(
                    _signUpText,
                    style: TextStyle(color: AppColors.violetE3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
