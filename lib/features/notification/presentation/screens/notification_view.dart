import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';

class NotificationView extends StatelessWidget {
  static String routeName = 'NotificationView';
  static String route = 'NotificationView';

  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ColorPalette.primaryColorLight2.withValues(alpha: 0.1),
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
                Icons.notifications_none_rounded,
                size: 72,
                color: ColorPalette.greyLightText,
              ),
              const Gap(16),
              const Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'You will see updates about your assigned jobs here once the notifications service is wired up.',
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
