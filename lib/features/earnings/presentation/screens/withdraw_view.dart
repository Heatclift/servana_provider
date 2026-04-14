import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_success.dart';

class WithdrawView extends StatefulWidget {
  static const String routeName = 'WithdrawView';
  static const String route = '/WithdrawView';
  const WithdrawView({super.key});

  @override
  State<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends State<WithdrawView> {
  String selectedPayment = 'PayPal';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 280,
            child: Container(
              color: ColorPalette.primaryColor,
              child: Column(
                children: [
                  const Gap(70),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const Gap(20),
                      const Text(
                        'Withdraw Earnings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      width: double.infinity,
                      height: 130,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Available for Withdrawal',
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(20),
                          Text(
                            '£ 1,213.00',
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Withdrawal Method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _buildPaymentMethodCard(
                      title: 'PayPal',
                      subtitle: 'Default Payment Method',
                      logo: 'assets/icons/svg/paypal.svg',
                    ),
                    const Gap(10),
                    _buildPaymentMethodCard(
                      title: 'Visa',
                      logo: 'assets/icons/svg/visa.svg',
                    ),
                    const Gap(10),
                    _buildPaymentMethodCard(
                      title: 'Card',
                      logo: 'assets/icons/svg/card.svg',
                    ),
                    const Gap(20),
                    _withdrawDetails(),
                    const Gap(20),
                    CustomButton(
                      onTap: () {
                        context.pushNamed(WithdrawSuccess.routeName);
                      },
                      buttonText: 'Confirm Withdrawal',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required String logo,
    required String title,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: ColorPalette.primaryColorLight2.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                logo,
                height: 40,
                width: 40,
              ),
              const Gap(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.greyLightText,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Radio(
                value: title,
                groupValue: selectedPayment,
                activeColor: ColorPalette.primaryColor,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _withdrawDetails() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Processing Time',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(5),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Bank Transfer: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '1-3 business days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Gap(5),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Debit Card: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Instant or up to X business days',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Gap(5),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'PayPal: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Within 24 hours',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
