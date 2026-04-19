import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';

class MessagingView extends StatelessWidget {
  static const String routeName = 'MessagingView';
  static const String route = '/MessagingView';

  const MessagingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ColorPalette.primaryColorLight2.withValues(alpha: 0.1),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: ColorPalette.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.forum_outlined,
                size: 72,
                color: ColorPalette.greyLightText,
              ),
              const Gap(16),
              const Text(
                'Messaging is not yet available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'Per-booking chat with the customer will be enabled once the messaging endpoints ship.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorPalette.greyText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
