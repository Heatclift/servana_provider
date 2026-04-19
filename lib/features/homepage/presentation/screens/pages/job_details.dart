import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/common/domain/services/utils.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api.dart';
import 'package:servana_cleaner_mobile/core/api/servana_api_exception.dart';
import 'package:servana_cleaner_mobile/core/api/session_profile.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_status.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/models/bookingrequest_model.dart';

enum _Action { accept, start, complete }

class JobDetailsView extends StatefulWidget {
  static const routeName = '/JobDetailsView';
  static const route = '/JobDetailsView';

  final BookingRequestModel booking;

  const JobDetailsView({super.key, required this.booking});

  @override
  State<JobDetailsView> createState() => _JobDetailsViewState();
}

class _JobDetailsViewState extends State<JobDetailsView> {
  JobCardsStore get _store => dpLocator<JobCardsStore>();
  ServanaApi get _api => dpLocator<ServanaApi>();

  _Action? _inFlight;

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChange);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChange);
    super.dispose();
  }

  void _onStoreChange() {
    if (mounted) setState(() {});
  }

  /// Prefer the store's current copy so optimistic patches show up here.
  BookingRequestModel get booking {
    for (final b in _store.jobs) {
      if (b.bookingId == widget.booking.bookingId) return b;
    }
    return widget.booking;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const Gap(16),
                  _buildServiceCard(),
                  const Gap(16),
                  _buildScheduleCard(),
                  const Gap(16),
                  _buildCustomerCard(),
                  const Gap(16),
                  _buildPaymentCard(),
                  const Gap(24),
                  ..._buildActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    );
  }

  Widget _buildSummaryCard() {
    final shortId = booking.bookingId.length > 8
        ? booking.bookingId.substring(0, 8)
        : booking.bookingId;
    return _Card(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking ID',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Gap(4),
                  Text(
                    '#$shortId',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            _statusPill(booking.status),
          ],
        ),
        const Gap(10),
        _paymentRow(),
      ],
    );
  }

  Widget _paymentRow() {
    final status = (booking.paymentStatus ?? '').toUpperCase();
    final method = _formatPaymentMethod(booking.paymentMethodUsed);
    final amountText = booking.totalAmount != null
        ? '₱${booking.totalAmount!.toStringAsFixed(2)}'
        : (booking.basePrice != null
            ? '₱${booking.basePrice!.toStringAsFixed(2)}'
            : '—');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _paymentPill(status),
            const Gap(8),
            Text(
              method,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
        Text(
          amountText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard() {
    final category = booking.level2;
    final name = booking.level3;
    final type = booking.serviceType;
    final addons = booking.addons;

    return _Card(
      title: 'Service',
      children: [
        if (category != null || name != null)
          Text(
            '${category ?? '—'}  ›  ${name ?? '—'}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        if (type != null) ...[
          const Gap(4),
          Text(
            _formatServiceType(type),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
        if (addons.isNotEmpty) ...[
          const Gap(12),
          const Text(
            'Add-ons',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Gap(6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: addons
                .map((a) => Chip(
                      label: Text(a, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                      backgroundColor:
                          ColorPalette.primaryColorLight.withValues(alpha: 0.12),
                    ))
                .toList(),
          ),
        ],
        if (booking.basePrice != null) ...[
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Base price', style: TextStyle(color: Colors.grey)),
              Text('₱${booking.basePrice!.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildScheduleCard() {
    final start = booking.slotStart ?? booking.scheduledAt;
    final end = booking.slotEnd;
    String when;
    if (start == null) {
      when = '—';
    } else if (end != null) {
      when =
          '${DateFormat('MMM d, y').format(start)}  •  ${DateFormat('h:mm a').format(start)} – ${DateFormat('h:mm a').format(end)}';
    } else {
      when = DateFormat('MMM d, y  •  h:mm a').format(start);
    }

    return _Card(
      title: 'Schedule & Branch',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const Gap(8),
            Expanded(
              child: Text(
                when,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        if (booking.branchName != null) ...[
          const Gap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.store_mall_directory_outlined,
                  size: 16, color: Colors.grey),
              const Gap(8),
              Expanded(
                child: Text(
                  booking.branchName!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCustomerCard() {
    final name = booking.customerName ?? '—';
    final phone = booking.customerPhone;
    final address = booking.addressText;

    return _Card(
      title: 'Customer',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person_outline, size: 16, color: Colors.grey),
            const Gap(8),
            Expanded(
              child: Text(name, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
        if (phone != null) ...[
          const Gap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
              const Gap(8),
              Text(phone, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ],
        if (address != null && address.isNotEmpty) ...[
          const Gap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.place_outlined, size: 16, color: Colors.grey),
              const Gap(8),
              Expanded(
                child: Text(address, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ],
        if (booking.addressLat != null && booking.addressLng != null) ...[
          const Gap(6),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              '${booking.addressLat!.toStringAsFixed(5)}, ${booking.addressLng!.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentCard() {
    final status = booking.paymentStatus ?? '—';
    final method = _formatPaymentMethod(booking.paymentMethodUsed);
    final total = booking.totalAmount;
    final base = booking.basePrice;

    return _Card(
      title: 'Payment',
      children: [
        _labelValue('Method', method),
        const Gap(6),
        _labelValue('Status', status),
        if (base != null) ...[
          const Gap(6),
          _labelValue('Base', '₱${base.toStringAsFixed(2)}'),
        ],
        if (total != null) ...[
          const Gap(6),
          _labelValue('Total', '₱${total.toStringAsFixed(2)}'),
        ],
      ],
    );
  }

  List<Widget> _buildActions() {
    final b = booking;
    final widgets = <Widget>[];

    if (JobStatus.canAccept(b)) {
      widgets.add(_actionButton(
        label: 'Accept Job',
        onTap: () => _handleAccept(),
        busy: _inFlight == _Action.accept,
      ));
    }

    if (JobStatus.canStart(b)) {
      widgets.add(_actionButton(
        label: 'Start Job',
        onTap: () => _handleStart(),
        busy: _inFlight == _Action.start,
      ));
    }

    if (JobStatus.canComplete(b)) {
      widgets.add(_actionButton(
        label: 'Mark Complete',
        onTap: () => _handleComplete(),
        busy: _inFlight == _Action.complete,
      ));
    }

    if (widgets.isEmpty) {
      widgets.add(
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle_outline,
                  size: 16, color: Colors.grey.shade600),
              const Gap(8),
              Expanded(
                child: Text(
                  JobStatus.isCompleted(b)
                      ? 'This booking is complete. Nothing to do here.'
                      : JobStatus.isCancelled(b)
                          ? 'This booking was cancelled.'
                          : 'No actions available for the current status.',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets
        .expand((w) => [w, const Gap(10)])
        .toList()
      ..removeLast();
  }

  Widget _actionButton({
    required String label,
    required VoidCallback onTap,
    required bool busy,
  }) {
    final disabled = _inFlight != null;
    return CustomButton(
      onTap: disabled ? () {} : onTap,
      buttonText: label,
      child: busy
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
    );
  }

  // --- action handlers -----------------------------------------------------

  String? _workerUid() {
    final uid = dpLocator<SessionProfile>().id;
    if (uid == null || uid.isEmpty) {
      showSnackBar(context, 'Session expired. Please sign in again.');
      return null;
    }
    return uid;
  }

  Future<void> _handleAccept() async {
    final uid = _workerUid();
    if (uid == null) return;
    setState(() => _inFlight = _Action.accept);
    try {
      await _api.acceptJob(bookingId: booking.bookingId, workerUid: uid);
      _store.patchBooking(booking.bookingId, status: 'ACCEPTED');
      if (!mounted) return;
      showSnackBar(context, 'Job accepted.');
    } on ServanaApiException catch (e) {
      if (mounted) showSnackBar(context, e.message);
    } catch (_) {
      if (mounted) showSnackBar(context, 'Could not accept the job.');
    } finally {
      if (mounted) setState(() => _inFlight = null);
      unawaited(_store.refresh());
    }
  }

  Future<void> _handleStart() async {
    final uid = _workerUid();
    if (uid == null) return;
    if (!mounted) return;
    final otp = await _promptOtp();
    if (otp == null || otp.isEmpty) return;
    if (!mounted) return;

    setState(() => _inFlight = _Action.start);
    try {
      await _api.confirmBookingOtp(bookingId: booking.bookingId, otp: otp);
      await _api.startJob(bookingId: booking.bookingId, workerUid: uid);
      _store.patchBooking(booking.bookingId, status: 'IN_PROGRESS');
      if (!mounted) return;
      showSnackBar(context, 'Job started.');
    } on ServanaApiException catch (e) {
      if (mounted) showSnackBar(context, e.message);
    } catch (_) {
      if (mounted) showSnackBar(context, 'Could not start the job.');
    } finally {
      if (mounted) setState(() => _inFlight = null);
      unawaited(_store.refresh());
    }
  }

  Future<void> _handleComplete() async {
    final uid = _workerUid();
    if (uid == null) return;
    final b = booking;

    if (JobStatus.canCollectCash(b)) {
      final amount = b.totalAmount ?? b.basePrice;
      final amountText = amount != null ? '₱${amount.toStringAsFixed(2)}' : 'the cash amount';
      if (!mounted) return;
      final ok = await _confirmCashCollected(amountText);
      if (ok != true) return;
    }

    setState(() => _inFlight = _Action.complete);
    var cashMarked = false;
    try {
      if (JobStatus.canCollectCash(b)) {
        await _api.markCashPaid(b.bookingId);
        _store.patchBooking(b.bookingId, paymentStatus: 'PAID');
        cashMarked = true;
      }
      await _api.completeJob(bookingId: b.bookingId, workerUid: uid);
      _store.patchBooking(b.bookingId, status: 'COMPLETED');
      if (!mounted) return;
      showSnackBar(context, 'Job completed.');
    } on ServanaApiException catch (e) {
      if (!mounted) return;
      if (cashMarked) {
        showSnackBar(
          context,
          'Cash recorded but could not mark the job complete — please tap Mark Complete again. (${e.message})',
        );
      } else {
        showSnackBar(context, e.message);
      }
    } catch (_) {
      if (!mounted) return;
      if (cashMarked) {
        showSnackBar(
          context,
          'Cash recorded but could not mark the job complete — please tap Mark Complete again.',
        );
      } else {
        showSnackBar(context, 'Could not complete the job.');
      }
    } finally {
      if (mounted) setState(() => _inFlight = null);
      unawaited(_store.refresh());
    }
  }

  // --- dialogs -------------------------------------------------------------

  Future<String?> _promptOtp() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Enter customer OTP'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ask the customer for the 6-digit code on their booking.',
                  style: TextStyle(fontSize: 13),
                ),
                const Gap(12),
                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  autofocus: true,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '123456',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.length != 6) return 'OTP must be 6 digits.';
                    if (int.tryParse(s) == null) return 'Digits only.';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  Navigator.of(ctx).pop(controller.text.trim());
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  Future<bool?> _confirmCashCollected(String amountText) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirm cash collected'),
          content: Text(
            'Please confirm you received $amountText in cash from the customer before completing this job.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Not yet'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Yes, I collected it"),
            ),
          ],
        );
      },
    );
  }

  Widget _labelValue(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _statusPill(String? raw) {
    final status = (raw ?? '').toUpperCase();
    final (bg, fg, label) = switch (status) {
      'COMPLETED' || 'DONE' || 'FINISHED' => (
          Colors.green.shade50,
          Colors.green.shade800,
          'Completed'
        ),
      'IN_PROGRESS' || 'STARTED' || 'ONGOING' => (
          Colors.blue.shade50,
          Colors.blue.shade800,
          'In Progress'
        ),
      'ACCEPTED' || 'APPROVED' || 'CONFIRMED_BY_WORKER' => (
          Colors.teal.shade50,
          Colors.teal.shade800,
          'Accepted'
        ),
      'CANCELLED' || 'CANCELED' => (
          Colors.red.shade50,
          Colors.red.shade700,
          'Cancelled'
        ),
      '' => (Colors.grey.shade200, Colors.grey.shade700, '—'),
      _ => (
          Colors.orange.shade50,
          Colors.orange.shade800,
          status.replaceAll('_', ' '),
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _paymentPill(String status) {
    final (bg, fg, label) = switch (status) {
      'PAID' => (Colors.green.shade50, Colors.green.shade800, 'Paid'),
      'PENDING_PAYMENT' => (
          Colors.orange.shade50,
          Colors.orange.shade800,
          'Payment Pending'
        ),
      'PENDING_OTP' => (
          Colors.grey.shade200,
          Colors.grey.shade700,
          'Awaiting OTP'
        ),
      '' => (Colors.grey.shade200, Colors.grey.shade700, '—'),
      _ => (
          Colors.blueGrey.shade50,
          Colors.blueGrey.shade700,
          status.replaceAll('_', ' '),
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatPaymentMethod(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    switch (raw.toUpperCase()) {
      case 'PAYMONGO':
        return 'Online Payment';
      case 'CASH':
        return 'Cash';
      case 'GCASH':
        return 'GCash';
      default:
        return raw;
    }
  }

  String _formatServiceType(String raw) {
    switch (raw.toUpperCase()) {
      case 'BEAUTY_AND_WELLNESS':
      case 'BEAUTY-AND-WELLNESS':
      case 'BW':
        return 'Beauty & Wellness';
      case 'AIRCON':
      case 'AIR_CON':
        return 'Aircon';
      default:
        return raw;
    }
  }
}

class _Card extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _Card({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}
