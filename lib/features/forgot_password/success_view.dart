import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';

class SuccessView extends StatelessWidget {
  static String routeName = "SuccessView";
  static String route = "/SuccessView";
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/success.png'),
            const Gap(40),
            Text(
              "We've sent a link to reset your password. Please check your inbox to create a new one.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorPalette.greyText,
              ),
            ),
            const Gap(20),
            MaterialButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              height: 50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: ColorPalette.primaryColorLight,
              child: const Center(
                child: Text(
                  "Go Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
