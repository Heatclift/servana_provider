import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:go_router/go_router.dart';
import 'package:tidy_cleaner_mobile/common/color_pallete.dart';
import 'package:tidy_cleaner_mobile/features/messaging/presentation/screens/chat_view.dart';

class MessagingView extends StatefulWidget {
  static const String routeName = 'MessagingView';
  static const String route = '/MessagingView';

  const MessagingView({super.key});

  @override
  State<MessagingView> createState() => _MessagingViewState();
}

class _MessagingViewState extends State<MessagingView> {
  final groupChats = [
    {
      'serviceName': 'Tidy Basic',
      'dateSchedule': 'Sept 26, 2024',
      'cleanerName': 'John Doe',
      'customerName': 'Maria Smith',
      'lastMessage': 'Maria: Hi there!',
      'time': '10:30 AM',
    },
    {
      'serviceName': 'Tidy Premium ',
      'dateSchedule': 'Sept 27, 2024',
      'cleanerName': 'Alex Turner',
      'customerName': 'Emma Watson',
      'lastMessage': 'Emma: See you tomorrow!',
      'time': '2:15 PM',
    },
    {
      'serviceName': 'Tidy Plus',
      'dateSchedule': 'Sept 28, 2024',
      'cleanerName': 'Jane Doe',
      'customerName': 'Chris Evans',
      'lastMessage': 'Alex: All set for the cleaning!',
      'time': '5:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColorLight2.withOpacity(0.1),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: ColorPalette.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: groupChats.length,
              itemBuilder: (context, index) {
                final groupChat = groupChats[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 675),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: ColorPalette.primaryColorLight2,
                          radius: 30,
                          child: Text(
                            groupChat['serviceName'].toString()[0],
                          ),
                        ),
                        title: Text(
                            '${groupChat['serviceName']} | ${groupChat['dateSchedule']}'),
                        subtitle: Text(
                          '${groupChat['lastMessage']}',
                        ),
                        trailing: Text('${groupChat['time']}'),
                        onTap: () {
                          context.pushNamed(
                            ChatView.routeName,
                            extra: {
                              'serviceName': groupChat['serviceName'],
                              'dateSchedule': groupChat['dateSchedule'],
                              'cleanerName': groupChat['cleanerName'],
                              'customerName': groupChat['customerName'],
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
