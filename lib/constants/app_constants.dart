import 'package:incognochat/models/chat_model.dart';

// Functions

String getRecepientID(final ChatModel chatModel, final String currentUserUID) {
  final recepientId = chatModel.participantsIds.firstWhere(
    (uid) => uid != currentUserUID,
    orElse: () => currentUserUID,
  );
  return recepientId;
}

T? safeCast<T>(dynamic value) {
  return value is T ? value : null;
}
