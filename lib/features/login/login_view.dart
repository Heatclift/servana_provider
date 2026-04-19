import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/common/domain/services/utils.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_textformfield.dart';
import 'package:servana_cleaner_mobile/core/api/auth_session.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api_exception.dart';
import 'package:servana_cleaner_mobile/core/api/session_profile.dart';
import 'package:servana_cleaner_mobile/features/forgot_password/forgot_password.dart';
import 'package:servana_cleaner_mobile/features/homepage/presentation/screens/homepage_view.dart';
import 'package:servana_cleaner_mobile/features/signup/signup_view.dart';

class LoginView extends StatefulWidget {
  static String routeName = "LoginView";
  static String route = "/LoginView";
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final api = dpLocator<ServanaApi>();
    final email = _emailController.text.trim();
    try {
      await api.signIn({
        'email': email,
        'password': _passwordController.text,
        'fcmToken': '',
      });
      await AuthSessionBootstrap.persist(dpLocator<AuthTokenHolder>().token);
      await AuthSessionBootstrap.persistProfile(dpLocator<SessionProfile>());
      if (!mounted) return;
      showSnackBar(context, 'Signed in successfully.');
      context.goNamed(HomepageView.routeName);
    } on ServanaApiException catch (e) {
      if (!mounted) return;
      if (_looksLikeUnverifiedEmail(e)) {
        _showUnverifiedEmailSnack(email, e.message);
      } else {
        showSnackBar(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _looksLikeUnverifiedEmail(ServanaApiException e) {
    final m = e.message.toLowerCase();
    return m.contains('verif') || m.contains('not verified');
  }

  void _showUnverifiedEmailSnack(String email, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 8),
        content: Text(
          message.isEmpty
              ? 'Email not verified. Please verify your email to continue.'
              : message,
        ),
        action: SnackBarAction(
          label: 'Resend email',
          onPressed: () => _resendVerification(email),
        ),
      ),
    );
  }

  Future<void> _resendVerification(String email) async {
    if (email.isEmpty) {
      showSnackBar(context, 'Enter your email first.');
      return;
    }
    try {
      await dpLocator<ServanaApi>().resendVerification(email);
      if (!mounted) return;
      showSnackBar(context, 'Verification email sent to $email.');
    } on ServanaApiException catch (e) {
      if (mounted) showSnackBar(context, e.message);
    } catch (_) {
      if (mounted) {
        showSnackBar(context, 'Could not resend verification email.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
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
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Please enter your email and password to access your account.',
                  style: TextStyle(
                    color: ColorPalette.greyText,
                  ),
                ),
                const Gap(50),
                CustomTextFormField(
                  labelText: ' Email',
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
                  labelText: ' Password',
                  controller: _passwordController,
                  fillColor: ColorPalette.primaryColorLight.withOpacity(0.02),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: ColorPalette.greyLightText,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.pushNamed(ForgotPassword.routeName);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const Gap(20),
                CustomButton(
                  onTap: _loading ? () {} : _submit,
                  buttonText: 'Log in',
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
                Row(
                  children: [
                    const Gap(20),
                    const Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'or continue with',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.greyLightText,
                      ),
                    ),
                    const Gap(20),
                    const Expanded(
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                    const Gap(20),
                  ],
                ),
                const Gap(20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () async {},
                        child: Image.asset(
                          "assets/icons/companies/google-g.png",
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () async {},
                        child: Image.asset(
                          "assets/icons/companies/logo-black.png",
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () async {},
                        child: Image.asset(
                          "assets/icons/companies/Facebook_Logo_Primary.png",
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (!kIsWeb &&
                          defaultTargetPlatform == TargetPlatform.iOS) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: () async {},
                          child: Image.asset(
                            "assets/icons/companies/apple.png",
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Gap(30),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: ColorPalette.greyLightText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: ColorPalette.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushNamed(SignUpView.routeName);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
