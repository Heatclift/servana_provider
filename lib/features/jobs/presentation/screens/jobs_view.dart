import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/widgets/custom_textformfield.dart';
import 'package:tidy_cleaner_mobile/features/homepage/presentation/screens/pages/job_details.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<JobsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final tabs = ['To Confirm', 'Upcoming', 'Ongoing', 'Completed', 'Cancelled'];
  List<Map<String, String>> bookingList = [
    {
      "id": "1",
      "status": "to confirm",
      "image": '',
      "title": "Tidy Premium",
      'price': '45.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "2",
      "status": "upcoming",
      "image":
          'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/Rectangle%208.png?alt=media&token=91945856-77c2-47db-bd06-52fa70c6c9e8',
      "title": "Tidy Basic",
      'price': '20.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "3",
      "status": "ongoing",
      "image":
          'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/Rectangle%208.png?alt=media&token=91945856-77c2-47db-bd06-52fa70c6c9e8',
      "title": "Booking 3",
      'price': '20.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "3",
      "status": "ongoing",
      "image":
          'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/Rectangle%208.png?alt=media&token=91945856-77c2-47db-bd06-52fa70c6c9e8',
      "title": "Tidy Basic",
      'price': '20.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "4",
      "status": "completed",
      "image":
          'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/Rectangle%208.png?alt=media&token=91945856-77c2-47db-bd06-52fa70c6c9e8',
      "title": "Tidy Premium",
      'price': '45.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "5",
      "status": "cancelled",
      "image":
          'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/Rectangle%208.png?alt=media&token=91945856-77c2-47db-bd06-52fa70c6c9e8',
      "title": "Tidy Premium",
      'price': '45.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "6",
      "status": "completed",
      "image":
          'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/Rectangle%208.png?alt=media&token=91945856-77c2-47db-bd06-52fa70c6c9e8',
      "title": "Tidy Premium",
      'price': '45.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
    {
      "id": "7",
      "status": "to confirm",
      "image": '',
      "title": "Tidy Premium",
      'price': '45.00',
      'description': 'Special Instruction : Focus on kitchen and living room',
    },
  ];
  @override
  void initState() {
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: ColorPalette.primaryColor,
            child: const Column(
              children: [
                Gap(80),
                Center(
                  child: Text(
                    'My Jobs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Gap(10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextFormField(labelText: 'Search..'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: ColorPalette.primaryColor,
                  child: TabBar(
                    controller: _tabController,
                    tabAlignment: TabAlignment.start,
                    physics: const ClampingScrollPhysics(),
                    isScrollable: true,
                    padding: const EdgeInsets.only(top: 20),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    dividerColor: ColorPalette.primaryColor,
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      fontSize: 18,
                      color: ColorPalette.primaryColorLight,
                    ),
                    tabs: tabs
                        .map((tab) => Tab(
                              text: tab,
                            ))
                        .toList(),
                    indicatorColor: ColorPalette.primaryColorLight,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: tabs
                        .map(
                          (tab) => buildBookingList(tab.toLowerCase()),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBookingList(String tab) {
    List<Map<String, String>> bookings = bookingList.where((booking) {
      return booking['status'] == tab;
    }).toList();

    if (bookings.isEmpty) {
      return Center(child: Text('There is no $tab booking'));
    }

    return ListView.separated(
      itemCount: bookings.length,
      padding: const EdgeInsets.all(20),
      separatorBuilder: (context, index) => const Gap(20),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return GestureDetector(
          onTap: () {
            context.pushNamed(JobDetailsView.routeName);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                        color: ColorPalette.greyLightText.withOpacity(0.5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: booking['image']!.isNotEmpty
                        ? Image.network(
                            booking['image'] ?? '',
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/gwana-350308.appspot.com/o/image%204.png?alt=media&token=c98011a2-dc81-4321-87fb-6177b8b15b40',
                              ),
                            ),
                          ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\u00A3${booking['price']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.greyLightText,
                        ),
                      ),
                      Text(
                        booking['description'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalette.greyLightText,
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        DateFormat('MMM dd yyyy').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ColorPalette.greyLightText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
