import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:incognochat/models/message_model.dart';
import 'package:incognochat/services/firebase/messages_service.dart';

final messagesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(messagesControllerProvider);
});

final messagesControllerProvider = NotifierProvider.autoDispose<MessagesController, Stream<List<MessageModel>>>(() => MessagesController());





class MessagesController extends AutoDisposeNotifier<Stream<List<MessageModel>>> {
  
  var limit = 20;

  @override
  Stream<List<MessageModel>> build() => ref.watch(messagesServiceProvider).getMessages(limit);

  bool loadNewMessages(int length) {
    if (length < limit) return false;
    limit += 20;
    state = ref.watch(messagesServiceProvider).getMessages(limit);
    return true;
  }


  Future<void> sendMessage(final String messageContent) async {
    await ref.watch(messagesServiceProvider).sendMessage(messageContent);
  }
  
  Future<void> markAsRead(final MessageModel messageModel) async {
    await ref.watch(messagesServiceProvider).markAsRead(messageModel);
  }
}
