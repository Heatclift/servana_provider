import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/common/domain/services/utils.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';
import 'package:servana_cleaner_mobile/core/api/session_profile.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_status.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/models/bookingrequest_model.dart';

class EarningsView extends StatefulWidget {
  const EarningsView({super.key});

  @override
  State<EarningsView> createState() => _EarningsViewState();
}

class _EarningsViewState extends State<EarningsView> {
  double scrollOffset = 0.0;
  final _draggableController = DraggableScrollableController();

  JobCardsStore get _store => dpLocator<JobCardsStore>();
  SessionProfile get _profile => dpLocator<SessionProfile>();

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChange);
    _profile.addListener(_onStoreChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _store.load());
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChange);
    _profile.removeListener(_onStoreChange);
    _draggableController.dispose();
    super.dispose();
  }

  void _onStoreChange() {
    if (mounted) setState(() {});
  }

  num _amountOf(BookingRequestModel b) =>
      b.totalAmount ?? b.basePrice ?? 0;

  DateTime? _whenOf(BookingRequestModel b) =>
      b.updatedAt ?? b.slotStart ?? b.scheduledAt ?? b.createdAt;

  /// Sum completed bookings whose timestamp is in [from, to).
  num _sumBetween(DateTime from, DateTime to) {
    num total = 0;
    for (final b in _store.jobs) {
      if (!JobStatus.isCompleted(b)) continue;
      final when = _whenOf(b);
      if (when == null) continue;
      if (when.isBefore(from) || !when.isBefore(to)) continue;
      total += _amountOf(b);
    }
    return total;
  }

  num _pendingTotal() {
    num total = 0;
    for (final b in _store.jobs) {
      if (JobStatus.isCompleted(b) || JobStatus.isCancelled(b)) continue;
      total += _amountOf(b);
    }
    return total;
  }

  num _lifetimeCompleted() {
    num total = 0;
    for (final b in _store.jobs) {
      if (JobStatus.isCompleted(b)) total += _amountOf(b);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final thisWeekStart = startOfToday.subtract(
      Duration(days: startOfToday.weekday - 1),
    );
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);

    final thisWeek = _sumBetween(thisWeekStart, now.add(const Duration(days: 1)));
    final lastWeek = _sumBetween(lastWeekStart, thisWeekStart);
    final thisMonth =
        _sumBetween(thisMonthStart, now.add(const Duration(days: 1)));
    final lastMonth = _sumBetween(lastMonthStart, thisMonthStart);

    final history = _store.jobs.where(JobStatus.isCompleted).toList()
      ..sort((a, b) {
        final ad = _whenOf(a) ?? DateTime(0);
        final bd = _whenOf(b) ?? DateTime(0);
        return bd.compareTo(ad);
      });

    return Scaffold(
      backgroundColor:
          ColorPalette.primaryColorLight2.withValues(alpha: 0.1),
      body: Stack(
        children: [
          _buildHeader(size),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (n) {
              setState(() => scrollOffset = n.extent);
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
                              padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: _buildSummaryCard(
                                thisWeek: thisWeek,
                                lastWeek: lastWeek,
                                thisMonth: thisMonth,
                                lastMonth: lastMonth,
                              ),
                            ),
                            _buildOtherInformation(),
                            const Gap(20),
                            _buildHistory(history),
                            const Gap(20),
                            CustomButton(
                              onTap: () => showSnackBar(
                                context,
                                'Withdraw flow is not yet available.',
                              ),
                              buttonText: 'Withdraw (coming soon)',
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

  Widget _buildHeader(Size size) {
    return Stack(
      children: [
        Container(
          height: 380,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF002F94), Color(0xFF648DDB)],
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
              Center(
                child: AnimatedBuilder(
                  animation: _profile,
                  builder: (context, _) {
                    final name = _profile.displayName;
                    final email = _profile.email ?? '';
                    return Column(
                      children: [
                        Text(
                          name.isEmpty ? 'Servana Provider' : name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (email.isNotEmpty)
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required num thisWeek,
    required num lastWeek,
    required num thisMonth,
    required num lastMonth,
  }) {
    Widget cell(String title, num value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₱${_fmt(value)}',
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

    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF855F), Color(0xFFE8443B)],
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
                  cell('This Week', thisWeek),
                  cell('This Month', thisMonth),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cell('Last Week', lastWeek),
                  cell('Last Month', lastMonth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherInformation() {
    final pending = _pendingTotal();
    final lifetime = _lifetimeCompleted();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Gap(10),
        _kv('Lifetime completed', '₱${_fmt(lifetime)}'),
        const Gap(6),
        _kv('Currently pending', '₱${_fmt(pending)}'),
      ],
    );
  }

  Widget _kv(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 15, color: ColorPalette.greyText)),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildHistory(List<BookingRequestModel> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Earnings History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Gap(10),
        if (_store.loading && history.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (history.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No completed jobs yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: history.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, i) => _historyTile(history[i]),
          ),
      ],
    );
  }

  Widget _historyTile(BookingRequestModel b) {
    final when = _whenOf(b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 1),
            color: Colors.grey.withValues(alpha: 0.15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.customerName ?? 'Customer',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  b.cleaningType,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                if (when != null)
                  Text(
                    DateFormat('MMM dd yyyy').format(when),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Text(
            '₱${_fmt(_amountOf(b))}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(num v) {
    final f = NumberFormat.decimalPattern('en_US');
    f.minimumFractionDigits = 2;
    f.maximumFractionDigits = 2;
    return f.format(v);
  }
}
