
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/models/chat_model.dart';

final currentChatControllerProvider = NotifierProvider<CurrentChatController, ChatModel?>(() => CurrentChatController());

class CurrentChatController extends Notifier<ChatModel?> {

  @override
  ChatModel? build() => null;
  
  void updateCurrentChat(ChatModel chatModel) => state = chatModel;

  void updateCurrentChatId(String id) {
    state = state?.copyWith(id: id);
  }
}