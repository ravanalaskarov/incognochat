import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/models/chat_model.dart';
import 'package:incognochat/services/firebase/chats_service.dart';

final chatsProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(chatsControllerProvider);
});

final chatsControllerProvider = NotifierProvider.autoDispose<ChatsController, Stream<List<ChatModel>>>(() => ChatsController());


class ChatsController extends AutoDisposeNotifier<Stream<List<ChatModel>>> {
  
  @override
  Stream<List<ChatModel>> build() => ref.read(chatsServiceProvider).getChats();


  Future<ChatModel> getChat(final String receipientID) async {
    return ref.read(chatsServiceProvider).getChat(receipientID);
  }
  

  Future<void> deleteChat(final String chatID) async {
    await ref.read(chatsServiceProvider).deleteChat(chatID);
  }

}



