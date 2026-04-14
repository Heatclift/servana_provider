import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) { final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
         Gap(size.height * 0.1),
          Text(
            'Earn and Get Paid with Ease',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: ColorPalette.primaryColor),
          ),
          const Gap(10),
          Text(
            'Receive payments directly to your account quickly and securely after each job. Your earnings are always safe with Tidy.',
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
