import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/features/homepage/data/models/bookingrequest_model.dart';
import 'package:tidy_cleaner_mobile/features/homepage/presentation/screens/pages/job_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeScreen> {
  double scrollOffset = 0.0;

  final ongoingRequests = [
    BookingRequestModel(
      cleaningType: 'Tidy Premium',
      customerName: 'Jade Abraham',
      price: '45.00',
      address: '13 Park Rd,	Sittingbourne, ME10 1DR',
      status: 'Ongoing',
      updated: DateTime.parse('2024-09-25 19:01:42.157714'),
    ),
    BookingRequestModel(
      cleaningType: 'Tidy Basic',
      customerName: 'Markus Gibson',
      price: '45.00',
      address: '13 Park Rd,	Sittingbourne, ME10 1DR',
      status: 'Ongoing',
      updated: DateTime.parse('2024-09-26 19:01:42.157714'),
    ),
  ];
  final pendingRequests = [
    BookingRequestModel(
      cleaningType: 'Tidy Plus',
      customerName: 'Lewis Clark',
      price: '45.00',
      address: '13 Park Rd,	Sittingbourne, ME10 1DR',
      status: 'Ongoing',
      updated: DateTime.parse('2024-09-27 19:01:42.157714'),
    ),
    BookingRequestModel(
      cleaningType: 'Tidy Premium',
      customerName: 'Flora Lorenz',
      price: '45.00',
      address: '13 Park Rd,	Sittingbourne, ME10 1DR',
      status: 'Ongoing',
      updated: DateTime.parse('2024-09-28 19:01:42.157714'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                height: 380,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF002F94),
                      Color(0xFF648DDB),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 30,
                child: Column(
                  children: [
                    Gap(size.height * 0.08),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/user_photo.png'),
                        ),
                      ),
                    ),
                    const Column(
                      children: [
                        Text(
                          'John Mark Dela Cruz',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'jmdelacruz@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Member Since: Sept 26, 2024',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -20,
                right: -30,
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF648DDB).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -30,
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFF648DDB).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              )
            ],
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                scrollOffset = notification.extent;
              });
              return true;
            },
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: size.height *
                        (scrollOffset > 0.67 ? scrollOffset : 0.55),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: scrollOffset > 0.9
                          ? null
                          : const BorderRadius.vertical(
                              top: Radius.elliptical(80, 40),
                            ),
                    ),
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.67,
                  minChildSize: 0.67,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            if (scrollOffset > 0.9) const Gap(kToolbarHeight),
                            // if (scrollOffset > 0.9) ...[
                            //   AnimatedContainer(
                            //     duration: const Duration(milliseconds: 100),
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 20),
                            //     child: Row(
                            //       children: [
                            //         Container(
                            //           height: 60,
                            //           width: 60,
                            //           decoration: const BoxDecoration(
                            //             borderRadius: BorderRadius.all(
                            //               Radius.circular(100),
                            //             ),
                            //             image: DecorationImage(
                            //               fit: BoxFit.fill,
                            //               image: AssetImage(
                            //                 'assets/images/user_photo.png',
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //         const Gap(10),
                            //         const Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               'John Mark Dela Cruz',
                            //               style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.w600,
                            //               ),
                            //             ),
                            //             Text(
                            //               'jmdelacruz@gmail.com',
                            //               style: TextStyle(
                            //                 fontSize: 12,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            //   const Gap(20),
                            // ],
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: _buildEarningsCard(),
                            ),
                            _buildMetricsGrid(),
                            const Gap(30),
                            _buildOngoingRequests(),
                            const Gap(30),
                            _buildPendingRequests(),
                            const Gap(10),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF855F),
              Color(0xFFE8443B),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '£ 1,213.00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Total Earnings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '£',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE8443B),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      children: [
        _buildMetricsCard(
          title: 'Pending',
          value: '3',
          icon: const Icon(
            Icons.pending_actions_rounded,
            size: 25,
            color: Colors.white,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0069BF),
              Color(0xFF2A9DF4),
            ],
          ),
        ),
        _buildMetricsCard(
          title: 'Ongoing',
          value: '6',
          icon: const Icon(
            Icons.loop,
            size: 25,
            color: Colors.white,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE89800),
              Color(0xFFFFD688),
            ],
          ),
        ),
        _buildMetricsCard(
          title: 'Completed',
          value: '8',
          icon: const Icon(
            Icons.check_circle_outline_rounded,
            size: 25,
            color: Colors.white,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF2727),
              Color(0xFFF39034),
            ],
          ),
        ),
        _buildMetricsCard(
          title: 'My Rating',
          value: '4.8',
          icon: const Icon(
            Icons.star,
            size: 25,
            color: Colors.white,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00C781),
              Color(0xFF66DDB3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOngoingRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ongoing Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 30,
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: ongoingRequests.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final request = ongoingRequests[index];
            return GestureDetector(
              onTap: () {
                context.pushNamed(JobDetailsView.routeName);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                ColorPalette.primaryColorLight.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/svg/notification_broom.svg',
                            height: 30,
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.customerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              request.cleaningType,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('MMM dd').format(request.updated),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPendingRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pending Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 30,
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: pendingRequests.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final request = pendingRequests[index];
            return GestureDetector(
              onTap: () {
                context.pushNamed(JobDetailsView.routeName);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                ColorPalette.primaryColorLight.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/svg/notification_broom.svg',
                            height: 30,
                          ),
                        ),
                        const Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.customerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              request.cleaningType,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      DateFormat('MMM dd').format(request.updated),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricsCard({
    required String title,
    required String value,
    required Widget icon,
    required Gradient gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                const Gap(10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              title == 'My Rating' ? 'Rating' : 'Quantity',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
