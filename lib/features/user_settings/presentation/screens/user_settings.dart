import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/core/api/auth_session.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';
import 'package:servana_cleaner_mobile/core/api/session_profile.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';
import 'package:servana_cleaner_mobile/features/login/login_view.dart';
import 'package:servana_cleaner_mobile/features/user_settings/presentation/screens/pages/profile.dart';
import 'package:servana_cleaner_mobile/features/user_settings/presentation/screens/pages/refer_friend.dart';

class UserSettingsView extends StatelessWidget {
  const UserSettingsView({super.key});

  Widget userProfile(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
            child: Image.asset(
              'assets/images/settings_bg.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.0, -0.5),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 70,
            child: Container(
              // color: ColorPalette.greyLightText,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Hero(
                    tag: 'imageUser',
                    child: Material(
                      elevation: 1,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/user_photo.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: AnimatedBuilder(
                      animation: dpLocator<SessionProfile>(),
                      builder: (context, _) {
                        final profile = dpLocator<SessionProfile>();
                        final name = profile.displayName;
                        final email = profile.email ?? '';
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isEmpty ? 'Servana Provider' : name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorPalette.greyLightText,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget settingItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          // Material(
          //   elevation: 1,
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.white,
          //   child: ListTile(
          //     title: const Text('Account'),
          //     trailing: Icon(Icons.chevron_right, color: ColorPalette.greyLightText),
          //   ),
          // ),
          // const Gap(10),
          // Material(
          //   elevation: 1,
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.white,
          //   child: ListTile(
          //     title: const Text('Notification'),
          //     trailing: Icon(Icons.chevron_right, color: ColorPalette.greyLightText),
          //   ),
          // ),
          // const Gap(10),
          // Material(
          //   elevation: 1,
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.white,
          //   child: ListTile(
          //     title: const Text('Coupons'),
          //     trailing: Icon(Icons.chevron_right, color: ColorPalette.greyLightText),
          //   ),
          // ),
          // const Gap(10),

          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            child: ListTile(
              title: const Text('Profile'),
              leading: const Icon(
                Icons.account_circle_outlined,
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: ColorPalette.greyLightText,
              ),
              onTap: () {
                context.pushNamed(ProfileView.routeName);
              },
            ),
          ),
          const Gap(10),
          GestureDetector(
            onTap: () {
              context.pushNamed(ReferFriendView.routeName);
            },
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: ListTile(
                title: const Text('Refer a Friend'),
                leading: const Icon(
                  Icons.group_add_outlined,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: ColorPalette.greyLightText,
                ),
              ),
            ),
          ),
          const Gap(30),
          GestureDetector(
            onTap: () {},
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(
                  Icons.lock_outline,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: ColorPalette.greyLightText,
                ),
              ),
            ),
          ),
          const Gap(10),
          GestureDetector(
            onTap: () {},
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: ListTile(
                title: const Text('Terms & Conditions'),
                leading: const Icon(
                  Icons.fact_check_outlined,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: ColorPalette.greyLightText,
                ),
              ),
            ),
          ),
          const Gap(30),

          GestureDetector(
            onTap: () async {
              await AuthSessionBootstrap.clear(
                dpLocator<AuthTokenHolder>(),
                dpLocator<SessionProfile>(),
              );
              dpLocator<JobCardsStore>().clear();
              if (context.mounted) {
                context.goNamed(LoginView.routeName);
              }
            },
            child: Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: ListTile(
                title: const Text('Logout'),
                leading: const Icon(
                  Icons.logout_outlined,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: ColorPalette.greyLightText,
                ),
              ),
            ),
          ),
          const Gap(24),
          // FutureBuilder(
          //   future: PackageInfo.fromPlatform(),
          //   builder: (
          //     BuildContext context,
          //     AsyncSnapshot<PackageInfo> snapshot,
          //   ) {
          //     if (snapshot.connectionState == ConnectionState.done &&
          //         snapshot.data != null) {
          //       return Center(
          //         child: Text(
          //           'Using ${Platform.isIOS ? 'iOS' : 'Android'} version ${snapshot.data?.version} Build ${snapshot.data?.buildNumber ?? ''} ',
          //           style: const TextStyle(
          //             color: Colors.grey,
          //             height: 1,
          //           ),
          //           textAlign: TextAlign.center,
          //         ),
          //       );
          //     }

          //     return const SizedBox();
          //   },
          // ),
          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 20),
          //   child: const Text(
          //     'Feedback',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   ),
          // ),
          // Material(
          //   elevation: 1,
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.white,
          //   child: ListTile(
          //     title: const Text('Help'),
          //     trailing: Icon(Icons.chevron_right, color: ColorPalette.greyLightText),
          //   ),
          // ),
          // const Gap(10),
          // Material(
          //   elevation: 1,
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.white,
          //   child: ListTile(
          //     title: const Text('Report a bug'),
          //     trailing: Icon(Icons.chevron_right, color: ColorPalette.greyLightText),
          //   ),
          // ),
          // const Gap(10),
          // Material(
          //   elevation: 1,
          //   borderRadius: BorderRadius.circular(10),
          //   color: Colors.white,
          //   child: ListTile(
          //     title: const Text('Send feedback'),
          //     trailing: Icon(Icons.chevron_right, color: ColorPalette.greyLightText),
          //   ),
          // ),
          // const Gap(10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColorLight2.withOpacity(0.1),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: ColorPalette.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            userProfile(context),
            settingItems(context),
          ],
        ),
      ),
    );
  }
}
