import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final bool sendByMe;

  const MessageItem({
    super.key,
    required this.message,
    required this.sendByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sendByMe ? Colors.purple : Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              message,
              style: TextStyle(
                color: sendByMe ? Colors.white : Colors.purple,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "10:10 AM",
              style: TextStyle(
                color:
                    (sendByMe ? Colors.white : Colors.purple).withOpacity(0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
