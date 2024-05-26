// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return _ChatModel.fromJson(json);
}

/// @nodoc
mixin _$ChatModel {
  String? get id => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  Object? get createdAt => throw _privateConstructorUsedError;
  Object? get lastUpdatedAt => throw _privateConstructorUsedError;
  List<String> get participantsIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatModelCopyWith<ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModelCopyWith<$Res> {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) then) =
      _$ChatModelCopyWithImpl<$Res, ChatModel>;
  @useResult
  $Res call(
      {String? id,
      String? lastMessage,
      Object? createdAt,
      Object? lastUpdatedAt,
      List<String> participantsIds});
}

/// @nodoc
class _$ChatModelCopyWithImpl<$Res, $Val extends ChatModel>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? lastMessage = freezed,
    Object? createdAt = freezed,
    Object? lastUpdatedAt = freezed,
    Object? participantsIds = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt ? _value.createdAt : createdAt,
      lastUpdatedAt:
          freezed == lastUpdatedAt ? _value.lastUpdatedAt : lastUpdatedAt,
      participantsIds: null == participantsIds
          ? _value.participantsIds
          : participantsIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatModelImplCopyWith<$Res>
    implements $ChatModelCopyWith<$Res> {
  factory _$$ChatModelImplCopyWith(
          _$ChatModelImpl value, $Res Function(_$ChatModelImpl) then) =
      __$$ChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? lastMessage,
      Object? createdAt,
      Object? lastUpdatedAt,
      List<String> participantsIds});
}

/// @nodoc
class __$$ChatModelImplCopyWithImpl<$Res>
    extends _$ChatModelCopyWithImpl<$Res, _$ChatModelImpl>
    implements _$$ChatModelImplCopyWith<$Res> {
  __$$ChatModelImplCopyWithImpl(
      _$ChatModelImpl _value, $Res Function(_$ChatModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? lastMessage = freezed,
    Object? createdAt = freezed,
    Object? lastUpdatedAt = freezed,
    Object? participantsIds = null,
  }) {
    return _then(_$ChatModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt ? _value.createdAt : createdAt,
      lastUpdatedAt:
          freezed == lastUpdatedAt ? _value.lastUpdatedAt : lastUpdatedAt,
      participantsIds: null == participantsIds
          ? _value._participantsIds
          : participantsIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$ChatModelImpl implements _ChatModel {
  const _$ChatModelImpl(
      {this.id,
      this.lastMessage,
      required this.createdAt,
      required this.lastUpdatedAt,
      required final List<String> participantsIds})
      : _participantsIds = participantsIds;

  factory _$ChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String? lastMessage;
  @override
  final Object? createdAt;
  @override
  final Object? lastUpdatedAt;
  final List<String> _participantsIds;
  @override
  List<String> get participantsIds {
    if (_participantsIds is EqualUnmodifiableListView) return _participantsIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantsIds);
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, lastMessage: $lastMessage, createdAt: $createdAt, lastUpdatedAt: $lastUpdatedAt, participantsIds: $participantsIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other.lastUpdatedAt, lastUpdatedAt) &&
            const DeepCollectionEquality()
                .equals(other._participantsIds, _participantsIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      lastMessage,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(lastUpdatedAt),
      const DeepCollectionEquality().hash(_participantsIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      __$$ChatModelImplCopyWithImpl<_$ChatModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatModelImplToJson(
      this,
    );
  }
}

abstract class _ChatModel implements ChatModel {
  const factory _ChatModel(
      {final String? id,
      final String? lastMessage,
      required final Object? createdAt,
      required final Object? lastUpdatedAt,
      required final List<String> participantsIds}) = _$ChatModelImpl;

  factory _ChatModel.fromJson(Map<String, dynamic> json) =
      _$ChatModelImpl.fromJson;

  @override
  String? get id;
  @override
  String? get lastMessage;
  @override
  Object? get createdAt;
  @override
  Object? get lastUpdatedAt;
  @override
  List<String> get participantsIds;
  @override
  @JsonKey(ignore: true)
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
