import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_status.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/models/bookingrequest_model.dart';
import 'package:servana_cleaner_mobile/features/homepage/presentation/screens/pages/job_details.dart';

class JobsView extends StatefulWidget {
  const JobsView({super.key});

  @override
  State<JobsView> createState() => _JobsViewState();
}

enum _Bucket { toConfirm, upcoming, ongoing, completed, cancelled }

class _JobsViewState extends State<JobsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const _tabs = [
    ('To Confirm', _Bucket.toConfirm),
    ('Upcoming', _Bucket.upcoming),
    ('Ongoing', _Bucket.ongoing),
    ('Completed', _Bucket.completed),
    ('Cancelled', _Bucket.cancelled),
  ];

  JobCardsStore get _store => dpLocator<JobCardsStore>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _store.addListener(_onStoreChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _store.load());
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onStoreChange() {
    if (mounted) setState(() {});
  }

  bool _matchesBucket(BookingRequestModel b, _Bucket bucket) {
    switch (bucket) {
      case _Bucket.toConfirm:
        return JobStatus.isToConfirm(b);
      case _Bucket.upcoming:
        return JobStatus.isUpcoming(b);
      case _Bucket.ongoing:
        return JobStatus.isOngoing(b);
      case _Bucket.completed:
        return JobStatus.isCompleted(b);
      case _Bucket.cancelled:
        return JobStatus.isCancelled(b);
    }
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
                Gap(20),
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
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    dividerColor: ColorPalette.primaryColor,
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: ColorPalette.primaryColorLight,
                    ),
                    tabs: _tabs.map((t) => Tab(text: t.$1)).toList(),
                    indicatorColor: ColorPalette.primaryColorLight,
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _store.refresh(),
                    child: TabBarView(
                      controller: _tabController,
                      children: _tabs
                          .map((t) => _buildTabBody(t.$2))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(_Bucket bucket) {
    if (_store.loading && _store.jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_store.error != null && _store.jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.red[300]),
              const Gap(8),
              Text(
                _store.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const Gap(12),
              TextButton(
                onPressed: () => _store.refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final bookings =
        _store.jobs.where((b) => _matchesBucket(b, bucket)).toList();
    if (bookings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text(
                'No ${_labelFor(bucket).toLowerCase()} jobs.',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: bookings.length,
      padding: const EdgeInsets.all(20),
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, i) => _buildTile(bookings[i]),
    );
  }

  String _labelFor(_Bucket b) {
    return _tabs.firstWhere((t) => t.$2 == b).$1;
  }

  Widget _buildTile(BookingRequestModel b) {
    final when = b.slotStart ?? b.scheduledAt ?? b.updatedAt;
    final whenText = when == null ? '—' : DateFormat('MMM dd yyyy').format(when);
    final price = b.totalAmount != null
        ? '₱${b.totalAmount!.toStringAsFixed(2)}'
        : (b.basePrice != null
            ? '₱${b.basePrice!.toStringAsFixed(2)}'
            : '—');

    return GestureDetector(
      onTap: () => context.pushNamed(
        JobDetailsView.routeName,
        extra: b,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 2),
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorPalette.primaryColorLight
                    .withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/svg/notification_broom.svg',
                height: 28,
              ),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.customerName ?? 'Customer',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    b.cleaningType,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  if ((b.addressText ?? '').isNotEmpty) ...[
                    const Gap(4),
                    Text(
                      b.addressText!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  const Gap(4),
                  Text(
                    whenText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(6),
                _statusChip(b),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(BookingRequestModel b) {
    final raw = JobStatus.norm(b);
    final label = raw.isEmpty ? '—' : raw.replaceAll('_', ' ');
    final color = JobStatus.isCompleted(b)
        ? Colors.green
        : JobStatus.isOngoing(b)
            ? Colors.blue
            : JobStatus.isCancelled(b)
                ? Colors.red
                : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
