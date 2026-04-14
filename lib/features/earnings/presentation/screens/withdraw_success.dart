import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:tidy_cleaner_mobile/features/earnings/presentation/screens/withdraw_tracking.dart';

class WithdrawSuccess extends StatelessWidget {
  static const routeName = 'WithdrawSuccess';
  static const route = '/WithdrawSuccess';
  const WithdrawSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(80),
                Image.asset('assets/images/success.png'),
                const Gap(20),
                const Text(
                  'Withdrawal Confirmed!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(10),
                Text(
                  'Your Withdrawal is on its Way!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.greyLightText,
                  ),
                ),
                const Gap(40),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Details:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(10),
                    Text(
                      'Withdrawal Amount: 💶 €275',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Gap(10),
                    Text(
                      'Withdrawal Method: 💳 Visa ****5678 ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What Happens Next?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gap(10),
                    Text(
                      '📅 Your funds are on their way and should arrive in your account by (Sept 30,2024)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Gap(10),
                    Text(
                      '🔔 You’ll receive a notification once the funds are available',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Gap(80),
                CustomButton(
                  onTap: () {
                    context.pushNamed(WithdrawTracking.routeName);
                  },
                  buttonText: 'Track Withdrawal',
                ),
                const Gap(20),
                CustomButton(
                  onTap: () {
                    context.pop();
                    context.pop();
                  },
                  buttonText: 'Go To Home',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
