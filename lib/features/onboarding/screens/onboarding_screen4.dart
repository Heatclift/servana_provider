import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Gap(size.height * 0.1),
          Text(
            'Get Started on Your Journey',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: ColorPalette.primaryColor),
          ),
          const Gap(10),
          Text(
            'We’re excited to have you onboard! Start accepting jobs, manage your schedule, and earn with confidence',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: ColorPalette.greyText,
            ),
          ),
        ],
      ),
    );
  }
}
