import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';

class JobDetailsView extends StatefulWidget {
  static const routeName = '/JobDetailsView';
  static const route = '/JobDetailsView';
  const JobDetailsView({super.key});

  @override
  State<JobDetailsView> createState() => _JobDetailsViewState();
}

class _JobDetailsViewState extends State<JobDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                        'Booking Details',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🆔 Booking Number: #123456",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "🧑 Client: John D",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "📍 Location: New York, NY",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "📅 Date: September 28, 2024, 10:00 AM",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "⏰ Duration: 3 hours",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "🧹 Job Type: Servana Plus",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "💰 Earnings: €45",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(20),
                  const Text(
                    "Additional Details:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "Specific Instructions: Please focus on cleaning the living room and kitchen areas. Pay extra attention to the windows.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "Notes: The client has a pet. Please be cautious.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    onTap: () {},
                    buttonText: 'Confirm Booking',
                  ),
                  const Gap(10),
                  CustomButton(
                    onTap: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Cancel Booking',
                        desc: 'Are you sure you want to Cancel this booking?',
                        btnCancelText: 'Yes, Cancel',
                        btnOkText: 'No, keep it',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    },
                    buttonText: 'Deny',
                    gradient: LinearGradient(
                      colors: [
                        Colors.red[100]!,
                        Colors.red,
                      ],
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
}
