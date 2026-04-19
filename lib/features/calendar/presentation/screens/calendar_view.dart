import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_cards_store.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/job_status.dart';
import 'package:servana_cleaner_mobile/features/homepage/data/models/bookingrequest_model.dart';
import 'package:servana_cleaner_mobile/features/homepage/presentation/screens/pages/job_details.dart';

class CalendarView extends StatefulWidget {
  static const String routeName = 'CalendarView';
  static const String route = '/CalendarView';
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  static DateTime _calendarFirstDay() => DateTime(2020, 1, 1);
  static DateTime _calendarLastDay() =>
      DateTime(DateTime.now().year + 5, 12, 31);

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  JobCardsStore get _store => dpLocator<JobCardsStore>();

  @override
  void initState() {
    super.initState();
    _selectedDay = _clamp(_normalize(_selectedDay));
    _focusedDay = _clamp(_normalize(_focusedDay));
    _store.addListener(_onStoreChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _store.load());
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChange);
    super.dispose();
  }

  void _onStoreChange() {
    if (mounted) setState(() {});
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _clamp(DateTime d) {
    final first = _calendarFirstDay();
    final last = _calendarLastDay();
    if (d.isBefore(first)) return first;
    if (d.isAfter(last)) return last;
    return d;
  }

  DateTime? _eventDay(BookingRequestModel b) {
    final when = b.slotStart ?? b.scheduledAt;
    return when == null ? null : _normalize(when);
  }

  Map<DateTime, List<BookingRequestModel>> _indexByDay() {
    final map = <DateTime, List<BookingRequestModel>>{};
    for (final b in _store.jobs) {
      final day = _eventDay(b);
      if (day == null) continue;
      map.putIfAbsent(day, () => []).add(b);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final byDay = _indexByDay();
    final selectedJobs = byDay[_selectedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Jobs Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _store.loading ? null : () => _store.refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_store.loading && _store.jobs.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            ),
          if (_store.error != null && _store.jobs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _store.error!,
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
          TableCalendar<BookingRequestModel>(
            firstDay: _calendarFirstDay(),
            lastDay: _calendarLastDay(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = _clamp(_normalize(selected));
                _focusedDay = _clamp(_normalize(focused));
              });
            },
            eventLoader: (d) => byDay[_normalize(d)] ?? const [],
            calendarBuilders: CalendarBuilders<BookingRequestModel>(
              singleMarkerBuilder: (context, date, b) {
                Color color = Colors.orange;
                if (JobStatus.isOngoing(b)) {
                  color = ColorPalette.primaryColor;
                } else if (JobStatus.isCompleted(b)) {
                  color = Colors.green;
                } else if (JobStatus.isCancelled(b)) {
                  color = Colors.red;
                }
                return Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
            daysOfWeekHeight: 40,
            rowHeight: 50,
            headerStyle: HeaderStyle(
              leftChevronVisible: true,
              rightChevronVisible: true,
              titleCentered: true,
              formatButtonVisible: false,
              headerPadding: const EdgeInsets.all(10),
              titleTextStyle: TextStyle(
                color: ColorPalette.primaryColor,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            calendarStyle: CalendarStyle(
              cellPadding: EdgeInsets.zero,
              cellMargin: const EdgeInsets.all(4),
              isTodayHighlighted: true,
              markersOffset: const PositionedOffset(start: 1, top: 1),
              markersAnchor: 1.4,
              selectedDecoration: BoxDecoration(
                color: ColorPalette.primaryColorLight,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: ColorPalette.primaryColorLight.withValues(alpha: 0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: selectedJobs.isEmpty
                ? const Center(
                    child: Text('No jobs for the selected date.'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            'My jobs for ${DateFormat('MMM dd yyyy').format(_selectedDay)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: selectedJobs.length,
                            separatorBuilder: (_, __) => const Gap(8),
                            itemBuilder: (context, i) =>
                                _buildJobCard(selectedJobs[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BookingRequestModel b) {
    final time = b.slotStart ?? b.scheduledAt;
    final timeText = time == null ? '—' : DateFormat('h:mm a').format(time);
    final price = b.totalAmount != null
        ? '₱${b.totalAmount!.toStringAsFixed(2)}'
        : (b.basePrice != null ? '₱${b.basePrice!.toStringAsFixed(2)}' : '—');

    Color statusColor = Colors.orange;
    if (JobStatus.isOngoing(b)) statusColor = ColorPalette.primaryColor;
    if (JobStatus.isCompleted(b)) statusColor = Colors.green;
    if (JobStatus.isCancelled(b)) statusColor = Colors.red;

    return GestureDetector(
      onTap: () =>
          context.pushNamed(JobDetailsView.routeName, extra: b),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
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
                  height: 26,
                ),
              ),
              const Gap(10),
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
                    Text(
                      b.cleaningType,
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorPalette.greyText,
                      ),
                    ),
                    Text(
                      timeText,
                      style: TextStyle(
                        fontSize: 13,
                        color: ColorPalette.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (b.status ?? '—').replaceAll('_', ' '),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
