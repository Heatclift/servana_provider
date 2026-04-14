import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_button.dart';

class ReferFriendView extends StatefulWidget {
  static String routeName = "ReferFriendView";
  static String route = "/ReferFriendView";
  const ReferFriendView({super.key});

  @override
  State<ReferFriendView> createState() => _ReferFriendViewState();
}

class _ReferFriendViewState extends State<ReferFriendView> {
  bool isCopied = false;
  final String referralCode = "ABC1234";

  void showRedeemCodeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            expand: false,
            builder: (_, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Redeem Your Code",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(20),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Enter Code',
                          hintText: 'Enter your redeem code here',
                        ),
                      ),
                      const Gap(40),
                      CustomButton(
                        onTap: () {},
                        buttonText: 'Redeem',
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
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
                        'Refer a friend',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'You will get',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    '5 Referral = 1 hour service',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 90,
                          child: Column(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    'assets/images/refer_friend.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const Gap(10),
                              const Text(
                                'Refer a friend',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                        width: 40,
                        child: Icon(
                          FontAwesomeIcons.arrowRightLong,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 105,
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    'assets/images/refer_friend2.png',
                                    fit: BoxFit.fitHeight,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            const Text(
                              'Get free service',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
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
                    const Text(
                      'REFERRAL CODE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Bring your friends to Tidy. Share your code!',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorPalette.greyLightText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Gap(10),
                    GestureDetector(
                      onTap: () {
                        if (isCopied == false) {
                          Clipboard.setData(ClipboardData(text: referralCode));
                          setState(() {
                            isCopied = true;
                          });
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              isCopied = false;
                            });
                          });
                        }
                      },
                      child: DottedBorder(
                        color: ColorPalette.primaryColorLight,
                        strokeWidth: 2,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [8, 3],
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: ColorPalette.primaryColorLight2
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                referralCode,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isCopied
                                  ? const Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Copied",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Row(
                                      children: [
                                        Icon(
                                          Icons.copy,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "Copy",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Text(
                      'Do you have a referral code?',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorPalette.greyLightText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          showRedeemCodeSheet();
                        },
                        child: Text(
                          'Redeem Code',
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorPalette.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    const Text(
                      'Earned Referrals',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(10),
                    _buildEarnedReferralCard(
                      name: 'Alexa Bell',
                      photo: '',
                    ),
                    const Gap(10),
                    _buildEarnedReferralCard(
                      name: 'Tony Marquez',
                      photo: '',
                    ),
                    const Gap(10),
                    _buildEarnedReferralCard(
                      name: 'Alison Conrad',
                      photo: '',
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEarnedReferralCard({
    required String name,
    required String photo,
  }) {
    final initials = name.split(' ');
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: ColorPalette.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${initials.first[0]} ${initials.last[0]}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Gap(10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
