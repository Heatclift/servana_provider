import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:tidy_cleaner_mobile/common/domain/services/utils.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_textformfield.dart';
import 'package:tidy_cleaner_mobile/core/api/servana_api.dart';
import 'package:tidy_cleaner_mobile/core/api/servana_api_exception.dart';
import 'package:tidy_cleaner_mobile/features/login/login_view.dart';

/// Servana role: technician (provider app). See Postman Auth Signup comments.
const int _kServanaRoleTechnician = 2;

class SignUpView extends StatefulWidget {
  static String routeName = "SignUpView";
  static String route = "/SignUpView";
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  ({String first, String last}) _splitName(String full) {
    final t = full.trim();
    final parts = t.split(RegExp(r'\s+'));
    if (parts.length == 1) return (first: parts.first, last: '');
    return (first: parts.first, last: parts.sublist(1).join(' '));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final api = dpLocator<ServanaApi>();
    final name = _splitName(_fullNameController.text);
    try {
      await api.signUp({
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'firstName': name.first,
        'lastName': name.last,
        'role': _kServanaRoleTechnician,
      });
      if (!mounted) return;
      showSnackBar(
        context,
        'Account created. Verify your email if required, then sign in.',
      );
      context.goNamed(LoginView.routeName);
    } on ServanaApiException catch (e) {
      if (mounted) showSnackBar(context, e.message);
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(90),
                  Center(
                    child: Image.asset(
                      'assets/images/tidy_cleaner_logo.png',
                      height: 100,
                    ),
                  ),
                  const Gap(30),
                  const Text(
                    'Get Started!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Excited to have you on board! Fill in your details to create a new account.',
                    style: TextStyle(
                      color: ColorPalette.greyText,
                    ),
                  ),
                  const Gap(50),
                  CustomTextFormField(
                    labelText: 'Full Name',
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorPalette.primaryColorLight.withOpacity(0.02),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: ColorPalette.greyLightText,
                    ),
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Enter your name';
                      if (s.split(RegExp(r'\s+')).length < 2) {
                        return 'Enter first and last name';
                      }
                      return null;
                    },
                  ),
                  const Gap(16),
                  CustomTextFormField(
                    labelText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorPalette.primaryColorLight.withOpacity(0.02),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: ColorPalette.greyLightText,
                    ),
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Enter your email';
                      if (!s.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const Gap(16),
                  CustomTextFormField(
                    labelText: 'Password',
                    controller: _passwordController,
                    fillColor: ColorPalette.primaryColorLight.withOpacity(0.02),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: ColorPalette.greyLightText,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter a password';
                      if (v.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const Gap(30),
                  CustomButton(
                    onTap: _loading ? () {} : _submit,
                    buttonText: 'Create Account',
                    child: _loading
                        ? const Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const Gap(20),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: ColorPalette.greyLightText,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.pushNamed(LoginView.routeName);
                              },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
