import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';



@freezed
class MessageModel with _$MessageModel {
  // ignore: invalid_annotation_target
  @JsonSerializable(includeIfNull: false)
  const factory MessageModel({
    String? id,
    required String senderId,
    required String recipientId,
    required String message,
    required Object? createdAt,
    @Default(false) bool isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    MessageModel message = MessageModel.fromJson(doc.data() as Map<String, dynamic>);
    return message.copyWith(id: doc.id);
  }
}
