import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_button.dart';

class JobDetails extends StatefulWidget {
  static String routeName = "JobDetails";
  static String route = "/JobDetails";
  const JobDetails({super.key, required this.bookingDetails});

  final Map<String, dynamic> bookingDetails;

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  void initState() {
    super.initState();
    _showRatingDialog();
  }

  void _showRatingDialog() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (widget.bookingDetails['status'] == 'completed') {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rate the Cleaning Service'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please rate the cleaning service you received:'),
                const SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  unratedColor: Colors.grey.withOpacity(0.5),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColorLight2),
                onPressed: () {
                  Navigator.of(context).pop();
                  // context.pushNamed(LeaveReviewScreen.routeName);
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryColorLight,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                            color: ColorPalette.greyLightText.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Booking ID: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Gap(10),
                              Text(
                                '123456789',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/images/booking_id.png',
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    GestureDetector(
                      onTap: () {
                        // context.pushNamed(CleanerProfile.routeName);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                              color:
                                  ColorPalette.greyLightText.withOpacity(0.5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Cleaner Profile',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // context.pushNamed(CleanerProfile.routeName);
                                  },
                                  child: const Text(
                                    'View',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(20),
                            Row(
                              children: [
                                Center(
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: ColorPalette.primaryColorLight,
                                        width: 3,
                                      ),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/cleaner_image2.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                const Text(
                                  'Joana Anderson',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                            color: ColorPalette.greyLightText.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildRowText(
                            title: 'Name',
                            data: 'John Doe',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Phone',
                            data: '+234 123 456 789',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Address',
                            data:
                                '17 Upper Rock Gardens, Brighton, East Sussex, United Kingdom',
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                            color: ColorPalette.greyLightText.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildRowText(
                            title: 'Service Details',
                            data: 'Tidy Basic',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Service Price',
                            data: '\u00A320.00',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Property Information',
                            data: 'Apartment with Red Gate',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Property Type',
                            data: 'Apartment',
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            offset: const Offset(0, 2),
                            color: ColorPalette.greyLightText.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildRowText(
                            title: 'Area Size to Clean',
                            data: '55sq/m',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Preferred Date',
                            data: DateFormat.yMMMd().format(
                                DateTime.now().add(const Duration(days: 3))),
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Preferred Time',
                            data: '8:00 AM',
                          ),
                          const Gap(10),
                          _buildRowText(
                            title: 'Notes',
                            data:
                                'Please focus on the kitchen and the bathroom. Pay extra attention to the windows and baseboards.',
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    if (widget.bookingDetails['status'] == 'ongoing')
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonHeight: 50,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red[100]!,
                                  Colors.red,
                                ],
                              ),
                              onTap: () {
                                _showCancellationSheet({});
                              },
                              buttonText: 'Cancel',
                            ),
                          ),
                        ],
                      ),
                    if (widget.bookingDetails['status'] == 'upcoming')
                      CustomButton(
                        buttonHeight: 50,
                        onTap: () {},
                        buttonText: 'Reschedule',
                      ),
                    if (widget.bookingDetails['status'] == 'completed')
                      CustomButton(
                        buttonHeight: 50,
                        onTap: () {
                          // context.pushNamed(LeaveReviewScreen.routeName);
                        },
                        buttonText: 'Leave a Review',
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

  Widget _buildRowText({required String title, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: ColorPalette.greyLightText,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Flexible(
          child: Text(
            data,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  void _showCancellationSheet(Map<String, dynamic> service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cancellation Policy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cancellations made within 24 hours of the service are subject to a 50% charge.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Refund Terms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Canceling your booking will result in a refund of £20 (after a £10 cancellation fee).\n\nRefunds will be processed within 3 business days after the cancellation.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Reason for Cancellation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          "Please let us know why you're canceling your booking to help us improve our service.",
                      hintStyle: const TextStyle(fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      _showSuccessCancellationSheet();
                    },
                    gradient: LinearGradient(
                      colors: [
                        Colors.red[100]!,
                        Colors.red,
                      ],
                    ),
                    buttonText: 'Yes, I want to cancel',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessCancellationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/success.png'),
                  const Gap(10),
                  const Text(
                    'Booking Cancelled',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(20),
                  const Text(
                    'Your booking has been successfully canceled. We hope to serve you again in the future.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(20),
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      // context.pushNamed(RefundScreen.routeName);
                      // _showRefundSheet();
                    },
                    buttonText: 'View Refund Details',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  void _showRefundSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/success.png'),
                  const Gap(10),
                  const Text(
                    'Refund Completed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(20),
                  const Text(
                    'Your refund has been successfully processed. The amount will reflect in your account shortly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(20),
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    buttonText: 'Go Back',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
