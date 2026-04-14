import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_button.dart';

class WithdrawReview extends StatefulWidget {
  static const routeName = 'WithdrawReview';
  static const route = '/WithdrawReview';
  const WithdrawReview({super.key});

  @override
  State<WithdrawReview> createState() => _WithdrawReviewState();
}

class _WithdrawReviewState extends State<WithdrawReview> {
  final _reviewController = TextEditingController();
  double _currentRating = 3;

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
                        'Review Withdrawal Request',
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Share you Experience',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Gap(20),
                    const Center(
                      child: Text(
                        'Please share your experience with our refund process. Your feedback helps us improve our services.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Gap(20),
                    Center(
                      child: Text(
                        '$_currentRating',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Gap(20),
                    Center(
                      child: RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                        unratedColor: Colors.grey.withOpacity(0.5),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      ),
                    ),
                    const Gap(20),
                    const Text(
                      'Let us know what you think!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    const Text(
                      'We value your feedback! Please share your experience regarding the transfer of your earnings to your bank account.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(20),
                    TextFormField(
                      minLines: 5,
                      maxLines: 10,
                      controller: _reviewController,
                      decoration: InputDecoration(
                        hintText: "Write your review here...",
                        hintStyle: TextStyle(
                          color: ColorPalette.greyLightText,
                        ),
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1,
                            color:
                                ColorPalette.primaryColorLight.withOpacity(0.5),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1,
                            color:
                                ColorPalette.primaryColorLight.withOpacity(0.5),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1,
                            color: ColorPalette.primaryColorLight,
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),
                    CustomButton(
                      onTap: () {
                        showThankYouDialog();
                      },
                      buttonText: 'Go to Homepage',
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

  void showThankYouDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/rating_success.png',
                height: 80,
              ),
              const Gap(20),
              const Center(
                child: Text(
                  "Thank You for Your Feedback!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(20),
              const Text(
                "Your review has been submitted successfully. We appreciate your input!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(10),
              const Text(
                "We appreciate your input!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(20),
              CustomButton(
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.pop();
                  context.pop();
                  context.pop();
                  context.pop();
                },
                buttonText: "Done",
              )
            ],
          ),
        );
      },
    );
  }
}
