import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_review.dart';

class WithdrawTracking extends StatefulWidget {
  static const routeName = 'WithdrawTracking';
  static const route = '/WithdrawTracking';
  const WithdrawTracking({super.key});

  @override
  State<WithdrawTracking> createState() => _WithdrawTrackingState();
}

class _WithdrawTrackingState extends State<WithdrawTracking> {
  int activeStep = 2;
  final refundSteps = [
    {
      'title': 'Withdrawal Initiated',
      'description': 'Your withdrawal request has been initiated.',
      'date': '2024-09-24 14:23:52.173436',
      'isFinished': true,
    },
    {
      'title': 'Withdrawal Approved',
      'description': 'Your withdrawal has been approved.',
      'date': '2024-09-24 08:36:52.173436',
      'isFinished': true,
    },
    {
      'title': 'Withdrawal Processing',
      'description': 'Your withdrawal is being processed.',
      'date': '2024-09-25 15:21:52.173436',
      'isFinished': true,
    },
    {
      'title': 'Expected Arrival',
      'description':
          'Expected to reflect in your account within 1-2 business days',
      'date': '',
      'isFinished': false,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 130,
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
                        'Track Your Withdrawal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreditCardWidget(
                    cardNumber: '1111 1111 1111 1111',
                    expiryDate: '12/24',
                    cardHolderName: 'Juan Dela Cruz',
                    isHolderNameVisible: true,
                    cvvCode: '123',
                    showBackView: false,
                    isSwipeGestureEnabled: false,
                    height: 200,
                    onCreditCardWidgetChange: (CreditCardBrand brand) {},
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(refundSteps.length, (index) {
                        return _buildStep(
                          title: refundSteps[index]['title']! as String,
                          description:
                              refundSteps[index]['description']! as String,
                          date: refundSteps[index]['date'] != ''
                              ? DateFormat('MMM dd yyyy, hh:mm a').format(
                                  DateTime.parse(
                                      refundSteps[index]['date']! as String))
                              : '',
                          isActive: activeStep == index,
                          isFinished: refundSteps[index]['isFinished']! as bool,
                          index: index,
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      onTap: () {
                        context.pushNamed(WithdrawReview.routeName);
                      },
                      buttonText: 'Submit Review',
                    ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      onTap: () {
                        context.pop();
                        context.pop();
                        context.pop();
                      },
                      buttonText: 'Go to Homepage',
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

  Widget _buildStep({
    required String title,
    required String description,
    required String date,
    required bool isActive,
    required bool isFinished,
    required int index,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Colors.white
                    : isFinished
                        ? ColorPalette.primaryColor
                        : Colors.grey,
                border: isActive
                    ? Border.all(
                        color: ColorPalette.primaryColor,
                        width: 8,
                      )
                    : null,
              ),
              child: isActive
                  ? null
                  : isFinished
                      ? const Icon(
                          Icons.check_circle_sharp,
                          color: Colors.white,
                          size: 18,
                        )
                      : null,
            ),
            if (index < 3)
              Container(
                height: 60,
                width: 2,
                color: isActive
                    ? Colors.grey
                    : isFinished
                        ? ColorPalette.primaryColor
                        : Colors.grey,
              ),
          ],
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Gap(4),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ],
    );
  }
}
