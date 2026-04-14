// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/common/custom_navbar/chip_style.dart';
import 'package:tidy_cleaner_mobile/common/custom_navbar/custom_navbar.dart';
import 'package:tidy_cleaner_mobile/common/custom_navbar/tab_item.dart';
import 'package:tidy_cleaner_mobile/common/custom_navbar/widgets/inspired/inspired.dart';
import 'package:tidy_cleaner_mobile/features/availability/presentation/screens/availability_view.dart';
import 'package:tidy_cleaner_mobile/features/calendar/presentation/screens/calendar_view.dart';
import 'package:tidy_cleaner_mobile/features/earnings/presentation/screens/earnings_view.dart';
import 'package:tidy_cleaner_mobile/features/homepage/presentation/screens/pages/home.dart';
import 'package:tidy_cleaner_mobile/features/jobs/presentation/screens/jobs_view.dart';
import 'package:tidy_cleaner_mobile/features/messaging/presentation/screens/messaging_view.dart';

class HomepageView extends StatefulWidget {
  static String routeName = "HomepageView";
  static String route = "/HomepageView";
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView>
    with SingleTickerProviderStateMixin {
  late PageController pageController;
  bool _isOptExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  int _bottomNavIndex = 0;
  String selectedMiddleTab = '';

  final _iconList = [
    'assets/icons/svg/home_icon.svg',
    'assets/icons/svg/broom_icon.svg',
    'assets/icons/svg/calendar_icon.svg',
    'assets/icons/svg/earnings.svg',
    'assets/icons/svg/messages_icon.svg',
  ];
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          _bottomNavIndex = v;
        },
        children: [
          const HomeScreen(),
          const JobsView(),
          selectedMiddleTab != ''
              ? selectedMiddleTab == 'Availability'
                  ? const AvailabilityView()
                  : const CalendarView()
              : const SizedBox(),
          const EarningsView(),
          const MessagingView(),
        ],
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _bottomNavIndex == 2
          ? Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (_isOptExpanded)
                  Container(
                    color: Colors.black54,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                Positioned(
                  bottom: 48,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      if (_isOptExpanded)
                        GestureDetector(
                          onTap: _toggleOptions,
                          child: Container(
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                      _buildOption(
                        icon: SvgPicture.asset(
                          "assets/icons/svg/calendar_icon.svg",
                          color: Colors.white,
                          height: 20,
                        ),
                        label: 'Availability',
                        color: ColorPalette.secondaryColor,
                        angle: -135,
                        diameter: 100,
                        onTap: () async {
                          _toggleOptions();
                          selectedMiddleTab = 'Availability';
                        },
                      ),
                      _buildOption(
                        icon: SvgPicture.asset(
                          "assets/icons/svg/calendar_icon.svg",
                          color: Colors.white,
                          height: 20,
                        ),
                        label: 'Calendar Schedule',
                        color: ColorPalette.primaryColorLight,
                        angle: -45,
                        diameter: 100,
                        onTap: () {
                          _toggleOptions();
                          selectedMiddleTab = 'Calendar Schedule';
                        },
                      ),
                      FloatingActionButton(
                        onPressed: _toggleOptions,
                        backgroundColor: ColorPalette.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide.none,
                        ),
                        heroTag: null,
                        key: UniqueKey(),
                        elevation: 0,
                        child: _isOptExpanded
                            ? const Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.white,
                              )
                            : Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorPalette.primaryColorLight,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/svg/calendar_icon.svg',
                                    color: ColorPalette.primaryColor,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : null,
      bottomNavigationBar: CustomBottomNavBar(
        indexSelected: _bottomNavIndex,
        items: [
          _bottomIcons(
            icon: _iconList[0],
            title: 'Home',
          ),
          _bottomIcons(
            icon: _iconList[1],
            title: 'Jobs',
          ),
          _bottomIcons(
            icon: _iconList[2],
            title: 'Calendar',
          ),
          _bottomIcons(
            icon: _iconList[3],
            title: 'Earnings',
          ),
          _bottomIcons(
            icon: _iconList[4],
            title: 'Messages',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            _bottomNavIndex = index;
            _toggleOptions();
            _bottomNavIndex = index;
            pageController.jumpToPage(_bottomNavIndex);
          } else {
            setState(() {
              _isOptExpanded = false;
              _controller.reverse();
            });
            _bottomNavIndex = index;
            pageController.jumpToPage(_bottomNavIndex);
          }

          setState(() {});
        },
        backgroundColor: Colors.white,
        color: Colors.grey,
        colorSelected: Colors.white,
        curve: Curves.easeInOut,
        itemStyle: ItemStyle.circle,
        iconSize: 25,
        height: 47,
        sizeInside: 55,
        top: -50,
        elevation: 0,
        chipStyle: ChipStyle(
          notchSmoothness: NotchSmoothness.smoothEdge,
          background: ColorPalette.primaryColor,
        ),
      ),
    );
  }

  TabItem _bottomIcons({
    required String icon,
    String title = '',
  }) {
    var isActiveIcon = _bottomNavIndex == _iconList.indexOf(icon);
    return TabItem(
      title: title,
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: isActiveIcon
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.primaryColorLight,
              )
            : null,
        child: Container(
          padding: isActiveIcon ? const EdgeInsets.all(8) : null,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: SvgPicture.asset(
            icon,
            color: isActiveIcon
                ? ColorPalette.primaryColor
                : ColorPalette.greyLightText,
          ),
        ),
      ),
    );
  }

  void _toggleOptions() {
    setState(() {
      _isOptExpanded = !_isOptExpanded;
      _isOptExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  Widget _buildOption({
    required Widget icon,
    required String label,
    required Color color,
    required double angle,
    double diameter = 85,
    required Function() onTap,
  }) {
    final double rad = angle * (pi / 180);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              diameter * _animation.value * cos(rad),
              diameter * _animation.value * sin(rad),
            ),
          child: Column(
            children: [
              if (_isOptExpanded)
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(height: 5),
              FloatingActionButton(
                onPressed: onTap,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                backgroundColor: color,
                child: icon,
              ),
            ],
          ),
        );
      },
    );
  }
}
