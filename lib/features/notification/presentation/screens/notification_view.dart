import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';

class NotificationView extends StatefulWidget {
  static String routeName = "NotificationView";
  static String route = "NotificationView";
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final notificationList = [
    {
      'title': 'Booking Confirmed',
      'body': 'Your cleaning service has been successfully booked.',
      'date': '2024-09-18 10:00 AM'
    },
    {
      'title': 'Booking Cancelled',
      'body': 'Your cleaning service booking has been cancelled.',
      'date': '2024-09-18 11:30 AM'
    },
    {
      'title': 'Cleaner Assigned',
      'body': 'A cleaner has been assigned to your booking.',
      'date': '2024-09-17 12:00 PM'
    },
    {
      'title': 'Cleaner On the Way',
      'body': 'Your cleaner is on the way and will arrive shortly.',
      'date': '2024-09-17 02:15 PM'
    },
    {
      'title': 'Service Completed',
      'body': 'Your cleaning service has been completed successfully.',
      'date': '2024-09-17 04:30 PM'
    },
    {
      'title': 'Payment Received',
      'body': 'Payment for your cleaning service has been received.',
      'date': '2024-09-17 05:00 PM'
    },
    {
      'title': 'Special Discount',
      'body': 'You have received a 10% discount on your next booking!',
      'date': '2024-09-16 06:00 PM'
    },
    {
      'title': 'Service Delayed',
      'body': 'Your cleaner is delayed and will arrive in 30 minutes.',
      'date': '2024-09-14 01:45 PM'
    },
    {
      'title': 'New Cleaning Packages Available',
      'body': 'Check out our new cleaning packages for deep cleaning and more!',
      'date': '2024-09-10 08:00 AM'
    },
    {
      'title': 'Service Reminder',
      'body': 'Reminder: Your cleaning service is scheduled for tomorrow.',
      'date': '2024-09-9 09:00 AM'
    },
  ];

  String formatNotificationDate(String dateString) {
    DateTime notificationDate =
        DateFormat("yyyy-MM-dd hh:mm a").parse(dateString);
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));

    // Check if the date is today
    if (DateFormat('yyyy-MM-dd').format(notificationDate) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return DateFormat('hh:mm a')
          .format(notificationDate); // Return time if it's today
    }

    // Check if the date is yesterday
    if (DateFormat('yyyy-MM-dd').format(notificationDate) ==
        DateFormat('yyyy-MM-dd').format(yesterday)) {
      return 'Yesterday';
    }

    // Check if the date is within the last 3 days
    if (now.difference(notificationDate).inDays <= 3) {
      return DateFormat('EEE').format(
          notificationDate); // Return the day of the week (e.g., Tuesday)
    }

    // For dates older than a week, return the full date (e.g., September 3)
    return DateFormat('MMM d').format(notificationDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColorLight2.withOpacity(0.1),
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
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notificationList.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) => const Gap(10),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 675),
                          child: SlideAnimation(
                            verticalOffset: 50,
                            child: FadeInAnimation(
                              child: Container(
                                height: 95,
                                width: double.infinity,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primaryColorLight
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/svg/notification_broom.svg',
                                        height: 30,
                                      ),
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  notificationList[index]
                                                          ['title'] ??
                                                      '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              const Gap(10),
                                              Text(
                                                formatNotificationDate(
                                                    notificationList[index]
                                                            ['date'] ??
                                                        ''),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Flexible(
                                            child: Text(
                                              notificationList[index]['body'] ??
                                                  '',
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorPalette.greyLightText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
