import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/widgets/custom_button.dart';

class AvailabilityView extends StatefulWidget {
  static const routeName = 'AvailabilityView';
  static const route = '/AvailabilityView';
  const AvailabilityView({super.key});

  @override
  State<AvailabilityView> createState() => _AvailabilityViewState();
}

class _AvailabilityViewState extends State<AvailabilityView> {
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  Set<int> selectedDays = {};
  Map<int, List<TimeOfDay>> availability = {};
  Map<int, bool> availabilityStatus = {};

  void toggleDay(int index) {
    setState(() {
      if (selectedDays.contains(index)) {
        selectedDays.remove(index);
      } else {
        selectedDays.add(index);
      }
    });
  }

  void addAvailability(TimeOfDay time) {
    setState(() {
      for (var day in selectedDays) {
        if (availability[day] == null) {
          availability[day] = [time];
        } else {
          availability[day]?.add(time);
        }
      }
    });
  }

  void _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      addAvailability(time);
    }
  }

  void toggleAvailabilityStatus(int day) {
    setState(() {
      availabilityStatus[day] = !(availabilityStatus[day] ?? true);
    });
  }

  @override
  void initState() {
    super.initState();

    selectedDays = {1, 3}; // this is test Monday and Wednesday
    availability = {
      1: [
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 14, minute: 0)
      ], // this is test for 1 - Monday: 9:00 AM and 2:00 PM
      3: [
        const TimeOfDay(hour: 11, minute: 0),
        const TimeOfDay(hour: 16, minute: 0)
      ], // this is test for 3 - Wednesday: 11:00 AM and 4:00 PM
    };
    availabilityStatus = {
      1: true, // Monday: Available
      3: true, // Wednesday: Available
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorPalette.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Availability',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(days.length, (index) {
                return GestureDetector(
                  onTap: () => toggleDay(index),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: selectedDays.contains(index)
                        ? ColorPalette.primaryColor
                        : Colors.grey[300],
                    child: Text(
                      days[index].substring(0, 3),
                      style: TextStyle(
                        color: selectedDays.contains(index)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const Gap(16),
            Expanded(
              child: selectedDays.isEmpty
                  ? const Center(
                      child: Text(
                        'Select a day to add and view your availability',
                      ),
                    )
                  : ListView(
                      children: (selectedDays.toList()..sort()).map((day) {
                        return Card(
                          color: ColorPalette.primaryColorShade,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('${days[day]} Availability'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: availability[day]?.map((time) {
                                    return Text(time.format(context));
                                  }).toList() ??
                                  [
                                    const Text('No availability added'),
                                  ],
                            ),
                            trailing: Switch(
                              value: availabilityStatus[day] ?? true,
                              onChanged: (value) =>
                                  toggleAvailabilityStatus(day),
                              activeColor: ColorPalette.primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            CustomButton(
              onTap: _pickTime,
              buttonText: 'Add Availability',
            ),
          ],
        ),
      ),
    );
  }
}
