import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed  
class ChatModel with _$ChatModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(includeIfNull: false)
  const factory ChatModel({
    String? id,
    String? lastMessage,
    required Object? createdAt,
    required Object? lastUpdatedAt,
    required List<String> participantsIds,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    ChatModel chat = ChatModel.fromJson(doc.data() as Map<String, dynamic>);
    return chat.copyWith(id: doc.id);
  }
}
