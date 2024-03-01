import 'package:flutter/material.dart';
import 'package:whatsapp_clone/theme/custom_theme_extension.dart';

import '../models/user_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: message.isSent ? 80 : 10,
        right: message.isSent ? 10 : 80,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: message.isSent
                  ? context.theme.senderChatCardBg
                  : context.theme.receiverChatCardBg,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black38),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  bottom: 8,
                  left: message.isSent ? 10 : 15,
                  right: message.isSent ? 15 : 10,
                ),
                child: Text(
                  "${message.text}         ",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 2,
              right: message.isSent ? 15 : 10,
              child: Text(
                message.time,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ))
        ],
      ),
    );
  }
}
