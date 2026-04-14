import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/services/utils.dart';

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

  final Map<DateTime, List<Map<String, String>>> jobEvents = {
    DateTime(2024, 10, 06): [
      {
        'status': 'ongoing',
        'clientName': 'John Doe',
        'serviceType': 'Servana Plus',
        'servicePrice': '£45',
        'date': 'Oct 06, 2024',
        'time': '10:00 AM',
      },
      {
        'status': 'pending',
        'clientName': 'Mary Johnson',
        'serviceType': 'Servana Plus',
        'servicePrice': '£45',
        'date': 'Oct 06, 2024',
        'time': '3:00 PM',
      }
    ],
    DateTime(2024, 10, 08): [
      {
        'status': 'pending',
        'clientName': 'Jane Matson',
        'serviceType': 'Servana Basic',
        'servicePrice': '£30',
        'date': 'Oct 08, 2024',
        'time': '1:00 PM',
      }
    ],
  };

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'ongoing':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Map<String, String>> _selectedJobs = [];

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _clampToCalendarRange(DateTime day) {
    final first = _calendarFirstDay();
    final last = _calendarLastDay();
    if (day.isBefore(first)) return first;
    if (day.isAfter(last)) return last;
    return day;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _clampToCalendarRange(_normalizeDate(_selectedDay));
    _focusedDay = _clampToCalendarRange(_normalizeDate(_focusedDay));
    _selectedJobs = jobEvents[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Cleaner Jobs Calendar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: _calendarFirstDay(),
            lastDay: _calendarLastDay(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(day, _selectedDay);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay =
                    _clampToCalendarRange(_normalizeDate(selectedDay));
                _focusedDay =
                    _clampToCalendarRange(_normalizeDate(focusedDay));
                _selectedJobs = jobEvents[_selectedDay] ?? [];
              });
            },
            eventLoader: (day) {
              return jobEvents[_normalizeDate(day)] ?? [];
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                var job = event as Map<String, String>;
                Color statusColor = Colors.grey;
                if (job['status'] == 'ongoing') {
                  statusColor = ColorPalette.primaryColor;
                } else if (job['status'] == 'pending') {
                  statusColor = Colors.yellow;
                }
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: statusColor,
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
                )),
            calendarStyle: CalendarStyle(
              cellPadding: const EdgeInsets.all(0),
              cellMargin: const EdgeInsets.all(4),
              isTodayHighlighted: false,
              markersOffset: const PositionedOffset(start: 1, top: 1),
              markersAnchor: 1.4,
              outsideTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1,
                color: ColorPalette.greyLightText,
              ),
              disabledTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1,
                color: ColorPalette.greyText,
              ),
              weekendTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1,
                color: ColorPalette.greyLightText,
              ),
              defaultTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1,
                color: ColorPalette.greyLightText,
              ),
              rangeHighlightColor: ColorPalette.primaryColorLight2,
              rangeStartDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: ColorPalette.primaryColor,
                shape: BoxShape.circle,
              ),
              rangeStartTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1,
                color: Colors.white,
              ),
              rangeEndTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                height: 1,
                color: Colors.white,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorPalette.primaryColorLight,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: ColorPalette.primaryColor,
              ),
              weekendStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: ColorPalette.primaryColor,
              ),
            ),
            onFormatChanged: (format) {},
          ),
          const SizedBox(height: 8),
          _selectedJobs.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'My Jobs for ${DateFormat('MMM dd yyyy').format(_selectedDay)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedJobs.length,
                            itemBuilder: (context, index) {
                              var job = _selectedJobs[index];
                              return _buildJobCard(job);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text('No jobs for the selected date.'),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, String> job) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorPalette.primaryColorLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/svg/notification_broom.svg',
                height: 30,
              ),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${job['clientName']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    job['serviceType'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorPalette.greyText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${job['date']} at ${job['time']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
                  capitalizeFirstLetter(string: job['status'] ?? ''),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _getStatusColor(job['status'] ?? ''),
                  ),
                ),
                Text(
                  job['servicePrice'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
