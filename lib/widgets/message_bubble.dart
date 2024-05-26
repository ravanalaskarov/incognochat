import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/app_constants.dart';
import 'package:incognochat/constants/enums.dart';
import 'package:incognochat/models/message_model.dart';
import 'package:intl/intl.dart';

class MessageBubble extends ConsumerWidget {
  final MessagePosition messagePosition;

  final MessageModel messageModel;
  final bool isMe;
  final User currentUser;
  const MessageBubble({
    super.key,
    required this.messageModel,
    required this.isMe,
    required this.messagePosition,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    const circularRadius = 12.0;
    bool is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    var messageBoxBorders = BorderRadius.circular(circularRadius);

    if (messagePosition == MessagePosition.first) {
      messageBoxBorders = BorderRadius.only(
        topLeft: const Radius.circular(circularRadius),
        topRight: const Radius.circular(circularRadius),
        bottomLeft: isMe ? const Radius.circular(circularRadius) : Radius.zero,
        bottomRight: isMe ? Radius.zero : const Radius.circular(circularRadius),
      );
    } else if (messagePosition == MessagePosition.last) {
      messageBoxBorders = BorderRadius.only(
        topLeft: isMe ? const Radius.circular(circularRadius) : Radius.zero,
        topRight: isMe ? Radius.zero : const Radius.circular(circularRadius),
        bottomLeft: const Radius.circular(circularRadius),
        bottomRight: const Radius.circular(circularRadius),
      );
    } else if (messagePosition == MessagePosition.middle) {
      messageBoxBorders = BorderRadius.only(
        topLeft: isMe ? const Radius.circular(circularRadius) : Radius.zero,
        topRight: isMe ? Radius.zero : const Radius.circular(circularRadius),
        bottomLeft: isMe ? const Radius.circular(circularRadius) : Radius.zero,
        bottomRight: isMe ? Radius.zero : const Radius.circular(circularRadius),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: isMe ? theme.colorScheme.primary : theme.colorScheme.secondary,
          borderRadius: messageBoxBorders,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14,
        ),
        // Margin around the bubble.
        margin: EdgeInsets.only(
          left: isMe ? 80 : 12,
          top: 4,
          right: isMe ? 12 : 80,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageModel.message,
              style: TextStyle(
                height: 1.3,
                color: isMe
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSecondary,
              ),
              softWrap: true,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            safeCast<Timestamp>(messageModel.createdAt) == null
                ? Icon(
                    Icons.schedule,
                    size: 15,
                    color: theme.colorScheme.onTertiary,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat(is24HoursFormat ? 'hh:mm' : 'hh:mm a')
                            .format(
                                (messageModel.createdAt as Timestamp).toDate()),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                      if (messageModel.senderId == currentUser.uid)
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            messageModel.isRead ? Icons.done_all : Icons.done,
                            size: 15,
                            color: theme.colorScheme.onTertiary,
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
