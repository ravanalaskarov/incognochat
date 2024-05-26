import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/constants/firebase_constants.dart';
import 'package:incognochat/controllers/auth_controller.dart';
import 'package:incognochat/core/chat_exception.dart';
import 'package:incognochat/models/chat_model.dart';
import 'package:incognochat/providers/firebaseproviders/firebase_providers.dart';

final chatsServiceProvider = Provider.autoDispose(
  (ref) {
    final fireStore = ref.watch(firebaseFirestoreProvider);
    final currentUser = ref.watch(authControllerProvider.notifier).currentUser;
    return ChatsService(
      fireStore: fireStore,
      currentUser: currentUser,
    );
  },
);

class ChatsService {
  final FirebaseFirestore _fireStore;
  final User _currentUser;
  ChatsService({
    required FirebaseFirestore fireStore,
    required User currentUser,
  })  : _fireStore = fireStore,
        _currentUser = currentUser;

  Query get _chats => _fireStore
      .collection(FirebaseConstants.chatsCollection)
      .where(
        'participantsIds',
        arrayContains: _currentUser.uid,
      )
      .orderBy(
        'lastUpdatedAt',
        descending: true,
      );

  Future<String> createChat(final ChatModel chatModel) async {
    final chatRef = await _fireStore
        .collection(FirebaseConstants.chatsCollection)
        .add(chatModel.toJson());
    return chatRef.id;
  }

  Future<void> deleteChat(final String chatID) async {
    final messagesCollection = await _fireStore
        .collection(FirebaseConstants.chatsCollection)
        .doc(chatID)
        .collection(FirebaseConstants.messagesCollection)
        .get();
    final batch = _fireStore.batch();
    for (final doc in messagesCollection.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(
        _fireStore.collection(FirebaseConstants.chatsCollection).doc(chatID));
    batch.commit();
  }

  Future<ChatModel> getChat(final String receipientID) async {
    if (receipientID == _currentUser.uid) {
      throw ChatException('You cannot chat with yourself');
    }

    final ongoingChat = await _fireStore
        .collection(FirebaseConstants.chatsCollection)
        .where(
          Filter.or(
            Filter(
              'participantsIds',
              isEqualTo: [_currentUser.uid, receipientID],
            ),
            Filter(
              'participantsIds',
              isEqualTo: [receipientID, _currentUser.uid],
            ),
          ),
        )
        .get();

    if (ongoingChat.docs.isNotEmpty) {
      final chatModel = ChatModel.fromFirestore(ongoingChat.docs.first);
      return chatModel;
    }

    final user = await _fireStore
        .collection(FirebaseConstants.usersCollection)
        .doc(receipientID)
        .get();

    if (!user.exists) {
      throw ChatException('User not found');
    }

    //Create new chat
    final newChatModel = ChatModel(
      participantsIds: [_currentUser.uid, receipientID],
      lastUpdatedAt: FieldValue.serverTimestamp(),
      createdAt: FieldValue.serverTimestamp(),
    );

    return newChatModel;
  }

  Stream<List<ChatModel>> getChats() {
    return _chats.snapshots().map(
      (event) {
        final chatsList =
            event.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();

        return chatsList;
      },
    );
  }
}
