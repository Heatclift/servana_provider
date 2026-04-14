import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/features/onboarding/screens/onboarding_screen1.dart';
import 'package:servana_cleaner_mobile/features/onboarding/screens/onboarding_screen2.dart';
import 'package:servana_cleaner_mobile/features/onboarding/screens/onboarding_screen3.dart';
import 'package:servana_cleaner_mobile/features/onboarding/screens/onboarding_screen4.dart';
import 'package:servana_cleaner_mobile/features/signup/signup_view.dart';

class OnboardingView extends StatefulWidget {
  static String routeName = "OnboardingView";
  static String route = "/OnboardingView";
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();
  int activePage = 0;
  bool isLastPage = false;

  void onIndexChange(int index) {
    setState(() {
      activePage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFB9DFF2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: PageView(
              controller: _controller,
              onPageChanged: onIndexChange,
              children: const [
                OnboardingScreen1(),
                OnboardingScreen2(),
                OnboardingScreen3(),
                OnboardingScreen4(),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/onboarding_image${activePage + 1}.png',
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (activePage < 3) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.pushNamed(SignUpView.routeName);
                      }
                    },
                    height: 50,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: ColorPalette.primaryColor,
                    child: Center(
                      child: Text(
                        activePage > 2 ? "Get Started" : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
