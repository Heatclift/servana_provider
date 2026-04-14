import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Gap(size.height * 0.1),
          Text(
            'Welcome to Servana\n',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: ColorPalette.primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Become a part of a trusted networ k of professional cleaners. Enjoy flexible hours, secure payments, and a supportive community.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: ColorPalette.greyText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
