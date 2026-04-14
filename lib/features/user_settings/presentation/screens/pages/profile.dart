import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_textformfield.dart';

class ProfileView extends StatefulWidget {
  static const routeName = 'ProfileView';
  static const route = '/ProfileView';
  const ProfileView({
    super.key,
    required this.data,
  });
  final Map<String, dynamic> data;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  String? _currentImageUrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = 'John Mark';
    _lastNameController.text = 'Dela Cruz';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        'Profile',
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: ColorPalette.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primaryColorLight,
                                  shape: BoxShape.circle,
                                ),
                                child: Hero(
                                  tag: 'imageUser',
                                  child: Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: _currentImageUrl == null
                                            ? const AssetImage(
                                                'assets/images/user_photo.png')
                                            : NetworkImage(
                                                _currentImageUrl ?? ''),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ColorPalette.primaryColorLight,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(28),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First Name',
                                  style: TextStyle(
                                    color: ColorPalette.greyLightText,
                                    fontSize: 14,
                                  ),
                                ),
                                const Gap(10),
                                CustomTextFormField(
                                  controller: _firstNameController,
                                  labelText: 'First Name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Name',
                                  style: TextStyle(
                                    color: ColorPalette.greyLightText,
                                    fontSize: 14,
                                  ),
                                ),
                                const Gap(10),
                                CustomTextFormField(
                                  controller: _lastNameController,
                                  labelText: 'Last Name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text(
                        'Address',
                        style: TextStyle(
                          color: ColorPalette.greyLightText,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(10),
                      CustomTextFormField(
                        controller: _addressController,
                        labelText: 'Address',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                      ),
                      const Gap(10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'City',
                                  style: TextStyle(
                                    color: ColorPalette.greyLightText,
                                    fontSize: 14,
                                  ),
                                ),
                                const Gap(10),
                                CustomTextFormField(
                                  controller: _cityController,
                                  labelText: 'City',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ZIP',
                                  style: TextStyle(
                                    color: ColorPalette.greyLightText,
                                    fontSize: 14,
                                  ),
                                ),
                                const Gap(10),
                                CustomTextFormField(
                                  controller: _zipController,
                                  labelText: 'Zip Code',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required.';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          color: ColorPalette.greyLightText,
                          fontSize: 14,
                        ),
                      ),
                      const Gap(10),
                      CustomTextFormField(
                        controller: _phoneNumberController,
                        labelText: 'Phone Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required.';
                          }
                          return null;
                        },
                      ),
                      const Gap(40),
                      CustomButton(
                        buttonText: 'Update',
                        onTap: () async {},
                      ),
                      const Gap(10),
                      CustomButton(
                        buttonText: 'Delete Account',
                        gradient: LinearGradient(
                          colors: [
                            Colors.red[100]!,
                            Colors.red,
                          ],
                        ),
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirm'),
                                backgroundColor: Colors.white,
                                content: const Text(
                                  'This action will delete your account permanently, continue?',
                                ),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey[400],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () async {},
                                    child: const Text(
                                      'Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
