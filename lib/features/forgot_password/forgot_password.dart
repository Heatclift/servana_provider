import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_textformfield.dart';
import 'package:servana_cleaner_mobile/features/forgot_password/success_view.dart';

class ForgotPassword extends StatelessWidget {
  static String routeName = "ForgotPassword";
  static String route = "/ForgotPassword";
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/servana_cleaner_logo.png',
                height: 100,
              ),
            ),
            const Gap(50),
            const Center(
              child: Text(
                'Forgot our Password?',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Center(
              child: Text(
                'We will send a verification code to your registered email address.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const Gap(20),
            const Text(
              'Email',
            ),
            const Gap(10),
            const CustomTextFormField(
              labelText: 'Enter Email',
            ),
            const Gap(50),
            MaterialButton(
              onPressed: () {
                context.pushNamed(SuccessView.routeName);
              },
              height: 50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: ColorPalette.primaryColorLight,
              child: const Center(
                child: Text(
                  "Submit",
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
