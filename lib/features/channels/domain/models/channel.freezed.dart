// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return _Channel.fromJson(json);
}

/// @nodoc
mixin _$Channel {
  String get id => throw _privateConstructorUsedError;
  String get workspaceId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get topic => throw _privateConstructorUsedError;
  String? get purpose => throw _privateConstructorUsedError;
  ChannelType get type => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChannelCopyWith<Channel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelCopyWith<$Res> {
  factory $ChannelCopyWith(Channel value, $Res Function(Channel) then) =
      _$ChannelCopyWithImpl<$Res, Channel>;
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String name,
      String? topic,
      String? purpose,
      ChannelType type,
      bool isArchived,
      int memberCount,
      int unreadCount,
      DateTime? lastMessageAt});
}

/// @nodoc
class _$ChannelCopyWithImpl<$Res, $Val extends Channel>
    implements $ChannelCopyWith<$Res> {
  _$ChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? name = null,
    Object? topic = freezed,
    Object? purpose = freezed,
    Object? type = null,
    Object? isArchived = null,
    Object? memberCount = null,
    Object? unreadCount = null,
    Object? lastMessageAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChannelType,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelImplCopyWith<$Res> implements $ChannelCopyWith<$Res> {
  factory _$$ChannelImplCopyWith(
          _$ChannelImpl value, $Res Function(_$ChannelImpl) then) =
      __$$ChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String workspaceId,
      String name,
      String? topic,
      String? purpose,
      ChannelType type,
      bool isArchived,
      int memberCount,
      int unreadCount,
      DateTime? lastMessageAt});
}

/// @nodoc
class __$$ChannelImplCopyWithImpl<$Res>
    extends _$ChannelCopyWithImpl<$Res, _$ChannelImpl>
    implements _$$ChannelImplCopyWith<$Res> {
  __$$ChannelImplCopyWithImpl(
      _$ChannelImpl _value, $Res Function(_$ChannelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workspaceId = null,
    Object? name = null,
    Object? topic = freezed,
    Object? purpose = freezed,
    Object? type = null,
    Object? isArchived = null,
    Object? memberCount = null,
    Object? unreadCount = null,
    Object? lastMessageAt = freezed,
  }) {
    return _then(_$ChannelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      workspaceId: null == workspaceId
          ? _value.workspaceId
          : workspaceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String?,
      purpose: freezed == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChannelType,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelImpl implements _Channel {
  const _$ChannelImpl(
      {required this.id,
      required this.workspaceId,
      required this.name,
      this.topic,
      this.purpose,
      this.type = ChannelType.public,
      this.isArchived = false,
      this.memberCount = 0,
      this.unreadCount = 0,
      this.lastMessageAt});

  factory _$ChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelImplFromJson(json);

  @override
  final String id;
  @override
  final String workspaceId;
  @override
  final String name;
  @override
  final String? topic;
  @override
  final String? purpose;
  @override
  @JsonKey()
  final ChannelType type;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final int memberCount;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final DateTime? lastMessageAt;

  @override
  String toString() {
    return 'Channel(id: $id, workspaceId: $workspaceId, name: $name, topic: $topic, purpose: $purpose, type: $type, isArchived: $isArchived, memberCount: $memberCount, unreadCount: $unreadCount, lastMessageAt: $lastMessageAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workspaceId, workspaceId) ||
                other.workspaceId == workspaceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, workspaceId, name, topic,
      purpose, type, isArchived, memberCount, unreadCount, lastMessageAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      __$$ChannelImplCopyWithImpl<_$ChannelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelImplToJson(
      this,
    );
  }
}

abstract class _Channel implements Channel {
  const factory _Channel(
      {required final String id,
      required final String workspaceId,
      required final String name,
      final String? topic,
      final String? purpose,
      final ChannelType type,
      final bool isArchived,
      final int memberCount,
      final int unreadCount,
      final DateTime? lastMessageAt}) = _$ChannelImpl;

  factory _Channel.fromJson(Map<String, dynamic> json) = _$ChannelImpl.fromJson;

  @override
  String get id;
  @override
  String get workspaceId;
  @override
  String get name;
  @override
  String? get topic;
  @override
  String? get purpose;
  @override
  ChannelType get type;
  @override
  bool get isArchived;
  @override
  int get memberCount;
  @override
  int get unreadCount;
  @override
  DateTime? get lastMessageAt;
  @override
  @JsonKey(ignore: true)
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
