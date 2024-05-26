// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String?,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      message: json['message'] as String,
      createdAt: json['createdAt'],
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['senderId'] = instance.senderId;
  val['recipientId'] = instance.recipientId;
  val['message'] = instance.message;
  writeNotNull('createdAt', instance.createdAt);
  val['isRead'] = instance.isRead;
  return val;
}
