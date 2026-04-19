import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/features/onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  static String routeName = "SplashView";
  static String route = "/SplashView";
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;
        context.goNamed(OnboardingView.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeInUp(
        duration: const Duration(seconds: 2),
        child: Center(
          child: Image.asset(
            'assets/images/tidy_cleaner_logo.png',
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
