import 'package:flutter/material.dart';
import 'package:yourplace/controller/chat_list.dart';

class ChatBubble extends StatelessWidget {
  final Chat chat;

  const ChatBubble({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment:
          chat.sent ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: chat.sent ? Colors.white : Colors.green,
            border: chat.sent
                ? Border.all(
                    color: Colors.green, style: BorderStyle.solid, width: 1.0)
                : null,
            borderRadius: BorderRadius.only(
                topRight: const Radius.circular(12),
                topLeft: const Radius.circular(12),
                bottomRight: chat.sent
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                bottomLeft: chat.sent
                    ? const Radius.circular(12)
                    : const Radius.circular(0)),
          ),
          constraints: BoxConstraints(
            maxWidth: screenSize.width * 0.6,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            chat.message,
            style: TextStyle(color: chat.sent ? Colors.black : Colors.white),
          ),
        ),
      ],
    );
  }
}
