import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/src/constants/app_colors.dart';
import 'package:flutter_riverpod_boilerplate/src/feature/authentication/application/firebase_auth_service.dart';
import 'package:flutter_riverpod_boilerplate/src/routing/business/business_router.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class SignInForm extends ConsumerStatefulWidget {
  SignInForm({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _loginFormKey = GlobalKey<FormBuilderState>();
  final _emailFieldKey = GlobalKey<FormBuilderFieldState>();

  bool _isForgotPasswordHovered = false;
  bool _isSignUpHovered = false;

  final String appName = 'Kaioras';
  final double _minWidth = 400.0;
  final String _welcomeText = 'Welcome Back~';
  final String _signInText = 'Sign in';
  final String _signUpText = 'Sign up here!';
  final String _forgotPasswordText = 'Forgot your password?';

  @override
  Widget build(BuildContext context) {
    void signUp() {
      debugPrint('Sign up clicked');
      context.goNamed(AppRoute.tenantSignUp.name);
    }

    void signIn() async {
      if (_loginFormKey.currentState?.saveAndValidate() ?? false) {
        final formData = _loginFormKey.currentState!.value;
        final email = formData['email'] as String;
        final password = formData['password'] as String;

        try {
          final authService = ref.read(authServiceProvider);
          await authService.signIn(email, password);
          // Navigation is now handled in AuthGate

          print('Sign-in successful'); // Add this debug print

          // Force refresh of auth state
          ref.refresh(currentAppUserProvider);
          print('Auth state refreshed'); // Add this debug print
        } on FirebaseAuthException catch (e) {
          String errorMessage;
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'No user found for that email.';
              break;
            case 'wrong-password':
              errorMessage = 'Wrong password provided for that user.';
              break;
            case 'invalid-email':
              errorMessage = 'The email address is badly formatted.';
              break;
            default:
              errorMessage = 'An error occurred. Please try again.';
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An unexpected error occurred. Please try again.'),
            ),
          );
        }
      }
    }

    void forgotPassword() {
      debugPrint('Forgot password clicked');
    }

    return Padding(
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
                      decoration: const InputDecoration(labelText: 'Password'),
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
                      onPressed: signIn,
                      child: Text(_signInText),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40.0),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isForgotPasswordHovered = true),
            onExit: (_) => setState(() => _isForgotPasswordHovered = false),
            child: GestureDetector(
              onTap: forgotPassword,
              child: Text(
                _forgotPasswordText,
                style: TextStyle(
                  color: AppColors.violetE3,
                  decoration: _isForgotPasswordHovered
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
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
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isSignUpHovered = true),
                onExit: (_) => setState(() => _isSignUpHovered = false),
                child: GestureDetector(
                  onTap: signUp,
                  child: Text(
                    _signUpText,
                    style: TextStyle(
                      color: AppColors.violetE3,
                      decoration: _isSignUpHovered
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
