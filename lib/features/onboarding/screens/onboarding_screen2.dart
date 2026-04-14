import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) { final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
       Gap(size.height * 0.1),
          Text(
            'Take Control of Your Time',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: ColorPalette.primaryColor,
            ),
          ),
          const Gap(10),
          Text(
            'Choose your availability and work when it’s most convenient for you. Get notified about cleaning jobs in your area!',
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
