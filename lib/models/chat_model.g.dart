// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String?,
      lastMessage: json['lastMessage'] as String?,
      createdAt: json['createdAt'],
      lastUpdatedAt: json['lastUpdatedAt'],
      participantsIds: (json['participantsIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('lastMessage', instance.lastMessage);
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('lastUpdatedAt', instance.lastUpdatedAt);
  val['participantsIds'] = instance.participantsIds;
  return val;
}
