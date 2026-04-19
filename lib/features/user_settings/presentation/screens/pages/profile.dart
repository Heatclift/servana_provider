import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/common/domain/services/utils.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_textformfield.dart';
import 'package:servana_cleaner_mobile/core/api/auth_session.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api_exception.dart';
import 'package:servana_cleaner_mobile/core/api/session_profile.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';
import 'package:servana_cleaner_mobile/features/login/login_view.dart';

class ProfileView extends StatefulWidget {
  static const routeName = 'ProfileView';
  static const route = '/ProfileView';

  const ProfileView({super.key});

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

  bool _loadingProfile = false;
  bool _saving = false;
  bool _archiving = false;

  @override
  void initState() {
    super.initState();
    _seedFromSession();
    WidgetsBinding.instance.addPostFrameCallback((_) => _hydrateFromServer());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _seedFromSession() {
    final p = dpLocator<SessionProfile>();
    _firstNameController.text = p.firstName ?? '';
    _lastNameController.text = p.lastName ?? '';
  }

  Future<void> _hydrateFromServer() async {
    final uid = dpLocator<SessionProfile>().id;
    if (uid == null || uid.isEmpty) return;
    setState(() => _loadingProfile = true);
    try {
      final res = await dpLocator<ServanaApi>().getUserProfile(uid);
      final data = _extractUser(res.data);
      if (data == null) return;
      _applyToForm(data);
      _maybeUpdateSession(data);
    } on ServanaApiException catch (e) {
      // Only surface the error if the user has nothing to look at; the seeded
      // SessionProfile values are enough for a best-effort view offline.
      final hasSeed = _firstNameController.text.trim().isNotEmpty;
      if (mounted && !hasSeed) showSnackBar(context, e.message);
    } catch (_) {
      // non-blocking — seeded values stay
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  Map<String, dynamic>? _extractUser(dynamic body) {
    if (body is Map) {
      final data = body['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
      return Map<String, dynamic>.from(body);
    }
    return null;
  }

  void _applyToForm(Map<String, dynamic> u) {
    String? pick(List<String> keys) {
      for (final k in keys) {
        final v = u[k];
        if (v != null && v.toString().isNotEmpty) return v.toString();
      }
      return null;
    }

    _firstNameController.text = pick(['firstName']) ?? _firstNameController.text;
    _lastNameController.text = pick(['lastName']) ?? _lastNameController.text;
    _phoneNumberController.text =
        pick(['phoneNumber', 'phone']) ?? _phoneNumberController.text;
    _addressController.text =
        pick(['address', 'addressLine']) ?? _addressController.text;
    _cityController.text = pick(['city']) ?? _cityController.text;
    _zipController.text =
        pick(['zip', 'zipCode', 'postalCode']) ?? _zipController.text;
    final avatar = pick(['avatar', 'photoUrl', 'profileImage']);
    if (avatar != null) _currentImageUrl = avatar;
    // Caller (_hydrateFromServer) triggers the rebuild via its finally-block.
  }

  /// Overwrites (NOT merges) the in-memory + persisted SessionProfile with
  /// fields from `u`, falling back to current values for any missing keys.
  /// `setFromSigninData` nulls every field it doesn't find, so we always
  /// build a complete map before calling it.
  void _maybeUpdateSession(Map<String, dynamic> u) {
    final profile = dpLocator<SessionProfile>();
    final refreshed = {
      'id': profile.id,
      'role': profile.role,
      'firstName': u['firstName'] ?? profile.firstName,
      'lastName': u['lastName'] ?? profile.lastName,
      'email': u['email'] ?? profile.email,
    };
    profile.setFromSigninData(refreshed);
    AuthSessionBootstrap.persistProfile(profile);
  }

  Future<void> _handleUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final uid = dpLocator<SessionProfile>().id;
    if (uid == null || uid.isEmpty) {
      showSnackBar(context, 'Session expired. Please sign in again.');
      return;
    }
    setState(() => _saving = true);
    try {
      final body = <String, dynamic>{
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'zip': _zipController.text.trim(),
      };
      await dpLocator<ServanaApi>().updateProfile(body);
      // SessionProfile only holds id/role/firstName/lastName/email;
      // phone/address/city/zip are intentionally not mirrored.
      _maybeUpdateSession(body);
      if (!mounted) return;
      showSnackBar(context, 'Profile updated.');
    } on ServanaApiException catch (e) {
      if (mounted) showSnackBar(context, e.message);
    } catch (_) {
      if (mounted) showSnackBar(context, 'Could not update your profile.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _handleArchive() async {
    final uid = dpLocator<SessionProfile>().id;
    if (uid == null || uid.isEmpty) {
      showSnackBar(context, 'Session expired. Please sign in again.');
      return;
    }
    setState(() => _archiving = true);
    try {
      await dpLocator<ServanaApi>().archiveUser(uid);
      await AuthSessionBootstrap.clear(
        dpLocator<AuthTokenHolder>(),
        dpLocator<SessionProfile>(),
      );
      dpLocator<JobCardsStore>().clear();
      if (!mounted) return;
      showSnackBar(context, 'Account archived.');
      context.goNamed(LoginView.routeName);
    } on ServanaApiException catch (e) {
      if (mounted) showSnackBar(context, e.message);
    } catch (_) {
      if (mounted) showSnackBar(context, 'Could not archive the account.');
    } finally {
      if (mounted) setState(() => _archiving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(),
                      const Gap(28),
                      if (_loadingProfile) ...[
                        const LinearProgressIndicator(),
                        const Gap(12),
                      ],
                      _buildNameRow(),
                      const Gap(10),
                      _labeled('Address', CustomTextFormField(
                        controller: _addressController,
                        labelText: 'Address',
                      )),
                      const Gap(10),
                      _buildCityZipRow(),
                      const Gap(10),
                      _labeled('Phone Number', CustomTextFormField(
                        controller: _phoneNumberController,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      )),
                      const Gap(40),
                      CustomButton(
                        buttonText: _saving ? 'Saving…' : 'Update',
                        onTap: _saving || _archiving ? () {} : _handleUpdate,
                        child: _saving
                            ? const Center(
                                child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const Gap(10),
                      CustomButton(
                        buttonText:
                            _archiving ? 'Archiving…' : 'Delete Account',
                        gradient: LinearGradient(
                          colors: [Colors.red[100]!, Colors.red],
                        ),
                        onTap: _saving || _archiving
                            ? () {}
                            : _confirmAndArchive,
                        child: _archiving
                            ? const Center(
                                child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
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

  Future<void> _confirmAndArchive() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete account'),
        backgroundColor: Colors.white,
        content: const Text(
          'This action will permanently archive your account. You will be signed out and cannot sign back in. Continue?',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey[400]),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true) await _handleArchive();
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Container(
        color: ColorPalette.primaryColor,
        child: Column(
          children: [
            const Gap(70),
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
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
    );
  }

  Widget _buildAvatar() {
    return Center(
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
                          ? const AssetImage('assets/images/user_photo.png')
                              as ImageProvider
                          : NetworkImage(_currentImageUrl!),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 0,
            child: GestureDetector(
              onTap: () => showSnackBar(context, 'Avatar upload coming soon.'),
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
          ),
        ],
      ),
    );
  }

  Widget _labeled(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorPalette.greyLightText,
            fontSize: 14,
          ),
        ),
        const Gap(10),
        field,
      ],
    );
  }

  Widget _buildNameRow() {
    return Row(
      children: [
        Expanded(
          child: _labeled('First Name', CustomTextFormField(
            controller: _firstNameController,
            labelText: 'First Name',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          )),
        ),
        const Gap(10),
        Expanded(
          child: _labeled('Last Name', CustomTextFormField(
            controller: _lastNameController,
            labelText: 'Last Name',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          )),
        ),
      ],
    );
  }

  Widget _buildCityZipRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _labeled('City', CustomTextFormField(
            controller: _cityController,
            labelText: 'City',
          )),
        ),
        const Gap(10),
        Expanded(
          child: _labeled('ZIP', CustomTextFormField(
            controller: _zipController,
            labelText: 'Zip Code',
          )),
        ),
      ],
    );
  }
}
