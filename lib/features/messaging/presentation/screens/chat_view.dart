// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';

class ChatView extends StatefulWidget {
  static const String routeName = 'ChatView';
  static const String route = '/ChatView';
  const ChatView({super.key, required this.groupInfo});
  final Map<String, dynamic> groupInfo;

  @override
  ChatViewState createState() => ChatViewState();
}

class ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  initMessages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    messages = [
      {
        'name': 'Servana Admin',
        'photoUrl': null,
        'text': 'Hi there! How are you?',
        'isMe': false,
        'time': TimeOfDay.fromDateTime(
                DateTime.now().subtract(const Duration(hours: 2)))
            .format(context),
      },
      {
        'name': 'Maria Smith',
        'photoUrl': null,
        'text': 'Hello everyone!',
        'isMe': false,
        'time': TimeOfDay.fromDateTime(
                DateTime.now().subtract(const Duration(minutes: 90)))
            .format(context),
      },
      {
        'name': 'John Doe',
        'photoUrl': null,
        'text': 'Hi! Let me know when we start.',
        'isMe': true,
        'time': TimeOfDay.fromDateTime(
                DateTime.now().subtract(const Duration(minutes: 30)))
            .format(context),
      },
    ];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initMessages();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add({
          'name': 'You',
          'photoUrl': null,
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': TimeOfDay.now().format(context),
        });
        _messageController.clear();
      });
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isMe = message['isMe'];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _buildAvatar(message),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? ColorPalette.primaryColorLight2 : Colors.white,
              borderRadius: isMe
                  ? BorderRadius.circular(20)
                  : const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    message['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                const Gap(5),
                Text(
                  message['text'],
                  style: const TextStyle(fontSize: 16),
                ),
                const Gap(5),
                Text(
                  message['time'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> message) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: ColorPalette.primaryColorLight2,
      backgroundImage: message['photoUrl'] != null
          ? NetworkImage(message['photoUrl'])
          : null,
      child: message['photoUrl'] == null
          ? Text(
              message['name'][0],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),
          Column(
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
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    ColorPalette.primaryColorLight2,
                                radius: 20,
                                child: Text(
                                  widget.groupInfo['serviceName'][0],
                                ),
                              ),
                              const Gap(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.groupInfo['serviceName']} | ${widget.groupInfo['dateSchedule']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${widget.groupInfo['cleanerName']}, ${widget.groupInfo['customerName']}, Servana Admin',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(
                      messages[messages.length - 1 - index],
                    );
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Gap(10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorPalette.primaryColorLight,
              ),
              child: const Center(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
