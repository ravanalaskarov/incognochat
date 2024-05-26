import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/app_constants.dart';
import 'package:incognochat/constants/enums.dart';
import 'package:incognochat/models/message_model.dart';
import 'package:incognochat/widgets/message_bubble.dart';
import 'package:intl/intl.dart';

class MessagesListView extends ConsumerWidget {
  final PageStorageBucket pageStorageBucket;
  final ScrollController scrollController;
  final List<MessageModel> currentMessages;
  final StreamController<int> renderedIndexStreamController;
  final User currentUser;
  const MessagesListView({
    super.key,
    required this.pageStorageBucket,
    required this.scrollController,
    required this.currentMessages,
    required this.renderedIndexStreamController,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageStorage(
      bucket: pageStorageBucket,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        key: const PageStorageKey('conversationScreenListViewKey'),
        reverse: true,
        shrinkWrap: false,
        controller: scrollController,
        itemBuilder: (ctx, index) {
          final currentMessage = currentMessages.elementAt(index);

          renderedIndexStreamController.add(index);
          final previousMessage = index + 1 < currentMessages.length
              ? currentMessages.elementAt(index + 1)
              : null;

          final nextMessage =
              index > 0 ? currentMessages.elementAt(index - 1) : null;

          String? formattedTime;

          final currentMessageTime =
              safeCast<Timestamp>(currentMessage.createdAt)?.toDate();
          final previousMessageTime =
              safeCast<Timestamp>(previousMessage?.createdAt)?.toDate();
          final nextMessageTime =
              safeCast<Timestamp>(nextMessage?.createdAt)?.toDate();

          if (currentMessageTime != null) {
            formattedTime =
                DateFormat.yMd(Localizations.localeOf(context).languageCode)
                    .format(currentMessageTime);
          }

          final differencePrevToCurrent =
              daysBetween(previousMessageTime, currentMessageTime);
          final differenceCurrentToNext =
              daysBetween(currentMessageTime, nextMessageTime);

          bool timeWillBeShown = differenceCurrentToNext > 0;
          bool timeIsShown = differencePrevToCurrent > 0;

          final isMe = currentMessage.senderId == currentUser.uid;
          final isPreviousSame =
              previousMessage?.senderId == currentMessage.senderId;
          final isNextSame = nextMessage?.senderId == currentMessage.senderId;

          late MessagePosition messagePosition;

          if (isPreviousSame &&
              isNextSame &&
              !timeWillBeShown &&
              !timeIsShown) {
            messagePosition = MessagePosition.middle;
          } else if (isNextSame && !timeWillBeShown) {
            messagePosition = MessagePosition.first;
          } else if (isPreviousSame && !timeIsShown) {
            messagePosition = MessagePosition.last;
          } else {
            messagePosition = MessagePosition.single;
          }

          return Column(
            children: [
              if ((timeIsShown || previousMessage == null) &&
                  formattedTime != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    formattedTime,
                  ),
                ),
              MessageBubble(
                messageModel: currentMessage,
                isMe: isMe,
                currentUser: currentUser,
                messagePosition: messagePosition,
              ),
            ],
          );
        },
        itemCount: currentMessages.length,
      ),
    );
  }

  int daysBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) {
      return 0;
    }

    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }
}
