import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/features/earnings/data/models/earnings_model.dart';
import 'package:servana_cleaner_mobile/features/earnings/presentation/screens/withdraw_view.dart';

class EarningsView extends StatefulWidget {
  const EarningsView({super.key});

  @override
  State<EarningsView> createState() => _EarningsViewState();
}

class _EarningsViewState extends State<EarningsView> {
  double scrollOffset = 0.0;
  final _draggableController = DraggableScrollableController();
  final List<EarningsModel> _earningsList = [
    EarningsModel(
      earningsId: 'E001',
      client: 'John Smith',
      price: '£75.50',
      cleaningType: 'Servana Premium',
      address: '221B Baker Street, London',
      status: 'Completed',
      updated: DateTime(2024, 9, 28, 14, 30),
    ),
    EarningsModel(
      earningsId: 'E002',
      client: 'Emily Clarke',
      price: '£45.30',
      cleaningType: 'Servana Plus',
      address: '10 Downing Street, London',
      status: 'Pending',
      updated: DateTime(2024, 9, 27, 10, 15),
    ),
    EarningsModel(
      earningsId: 'E003',
      client: 'William Brown',
      price: '£98.70',
      cleaningType: 'Servana Premium',
      address: '25 The Crescent, Manchester',
      status: 'Completed',
      updated: DateTime(2024, 9, 26, 16, 45),
    ),
    EarningsModel(
      earningsId: 'E004',
      client: 'Sarah Johnson',
      price: '£63.20',
      cleaningType: 'Servana Basic',
      address: '5 Royal Avenue, Liverpool',
      status: 'Ongoing',
      updated: DateTime(2024, 9, 25, 11, 0),
    ),
    EarningsModel(
      earningsId: 'E005',
      client: 'Michael Taylor',
      price: '£32.80',
      cleaningType: 'Servana Basic',
      address: '12 High Street, Birmingham',
      status: 'Cancelled',
      updated: DateTime(2024, 9, 24, 9, 30),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorPalette.primaryColorLight2.withOpacity(0.1),
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
              const Padding(
                padding: EdgeInsets.only(top: 50, left: 20),
                child: Text(
                  'My Earnings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(size.height * 0.08),
                    Center(
                      child: Container(
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
                    ),
                    const Center(
                      child: Column(
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
              ),
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
                    height: MediaQuery.of(context).size.height *
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
                  controller: _draggableController,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            if (scrollOffset > 0.9) const Gap(50),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: _buildEarningsCard(),
                            ),
                            _buildOtherInformation(),
                            const Gap(20),
                            _earningsHistory(),
                            const Gap(20),
                            CustomButton(
                              onTap: () {
                                context.pushNamed(WithdrawView.routeName);
                                setState(() {
                                  scrollOffset = 0.67;
                                  _draggableController.jumpTo(0);
                                  scrollController.jumpTo(0);
                                });
                              },
                              buttonText: 'Withdraw',
                            ),
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
    Widget buildData({required String title, required String value}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 180,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildData(title: 'This Week', value: '£ 213.00'),
                  buildData(title: 'This Month', value: '£ 1,213.00'),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildData(title: 'Last Week', value: '£ 422.00'),
                  buildData(title: 'Last Month', value: '£ 1,176.00'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Other Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Gap(10),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: 'Next Payout: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: 'Sept. 30, 2024',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          style: TextStyle(
            fontSize: 16,
            color: ColorPalette.greyText,
          ),
        ),
        const Gap(10),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: 'Pending Amount: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text:
                    'If there are any jobs with pending payments: "Pending Earnings: €50.00"',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          style: TextStyle(
            fontSize: 16,
            color: ColorPalette.greyText,
          ),
        ),
      ],
    );
  }

  Widget _earningsHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Earnings History',
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
          itemCount: _earningsList.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final earning = _earningsList[index];
            return Container(
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
                        child: Image.asset(
                          'assets/icons/earnings_icon.png',
                          height: 30,
                        ),
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            earning.client,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            earning.cleaningType,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd yyyy').format(earning.updated),
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
                    earning.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
