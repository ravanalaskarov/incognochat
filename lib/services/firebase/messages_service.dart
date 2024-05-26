import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/app_constants.dart';
import 'package:incognochat/constants/firebase_constants.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/controllers/current_chat_controller.dart';
import 'package:incognochat/models/chat_model.dart';
import 'package:incognochat/models/message_model.dart';
import 'package:incognochat/providers/firebaseproviders/firebase_providers.dart';

final messagesServiceProvider = Provider.autoDispose(
  (ref) {
    final fireStore = ref.watch(firebaseFirestoreProvider);
    final currentChat = ref.watch(currentChatControllerProvider);
    final currentUser = ref.watch(authControllerProvider.notifier).currentUser;
    return MessagesService(
      fireStore: fireStore,
      currentChat: currentChat,
      user: currentUser,
    );
  },
);

class MessagesService {
  final FirebaseFirestore _fireStore;
  final ChatModel _currentChat;
  final User _user;
  MessagesService({
    required FirebaseFirestore fireStore,
    required ChatModel? currentChat,
    required User user,
  })  : _fireStore = fireStore,
        _currentChat = currentChat!,
        _user = user;

  Query get _messages => _fireStore
      .collection(FirebaseConstants.chatsCollection)
      .doc(_currentChat.id)
      .collection('messages')
      .orderBy(
        'createdAt',
        descending: true,
      );

  Stream<List<MessageModel>> getMessages(final int limit) {
    return _messages.limit(limit).snapshots().map(
      (event) {
        return event.docs.map((e) => MessageModel.fromFirestore(e)).toList();
      },
    );
  }

  Future<void> markAsRead(final MessageModel messageModel) async {
    if (messageModel.isRead) return;
    if (messageModel.senderId == _user.uid) return;
    await _fireStore
        .collection(FirebaseConstants.chatsCollection)
        .doc(_currentChat.id)
        .collection('messages')
        .doc(messageModel.id)
        .update(
      {
        'isRead': true,
      },
    );
  }

  Future<void> sendMessage(final String message) async {
    final messageModel = MessageModel(
      senderId: _user.uid ,
      recipientId: getRecepientID(_currentChat, _user.uid),
      message: message,
      createdAt: FieldValue.serverTimestamp(),
    );

    await _fireStore
        .collection(FirebaseConstants.chatsCollection)
        .doc(_currentChat.id)
        .collection('messages')
        .add(
          messageModel.toJson(),
        );

    await _fireStore
        .collection(FirebaseConstants.chatsCollection)
        .doc(_currentChat.id)
        .update(
      {
        'lastUpdatedAt': FieldValue.serverTimestamp(),
        'lastMessage': message,
      },
    );
  }
}
