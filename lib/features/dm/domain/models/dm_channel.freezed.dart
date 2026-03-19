// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dm_channel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DmChannel _$DmChannelFromJson(Map<String, dynamic> json) {
  return _DmChannel.fromJson(json);
}

/// @nodoc
mixin _$DmChannel {
  String get id => throw _privateConstructorUsedError;

  /// List of participant user objects (excluding the current user for display).
  List<DmParticipant> get members => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  String? get lastMessageText => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DmChannelCopyWith<DmChannel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DmChannelCopyWith<$Res> {
  factory $DmChannelCopyWith(DmChannel value, $Res Function(DmChannel) then) =
      _$DmChannelCopyWithImpl<$Res, DmChannel>;
  @useResult
  $Res call(
      {String id,
      List<DmParticipant> members,
      int unreadCount,
      String? lastMessageText,
      DateTime? lastMessageAt});
}

/// @nodoc
class _$DmChannelCopyWithImpl<$Res, $Val extends DmChannel>
    implements $DmChannelCopyWith<$Res> {
  _$DmChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? members = null,
    Object? unreadCount = null,
    Object? lastMessageText = freezed,
    Object? lastMessageAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<DmParticipant>,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageText: freezed == lastMessageText
          ? _value.lastMessageText
          : lastMessageText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DmChannelImplCopyWith<$Res>
    implements $DmChannelCopyWith<$Res> {
  factory _$$DmChannelImplCopyWith(
          _$DmChannelImpl value, $Res Function(_$DmChannelImpl) then) =
      __$$DmChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      List<DmParticipant> members,
      int unreadCount,
      String? lastMessageText,
      DateTime? lastMessageAt});
}

/// @nodoc
class __$$DmChannelImplCopyWithImpl<$Res>
    extends _$DmChannelCopyWithImpl<$Res, _$DmChannelImpl>
    implements _$$DmChannelImplCopyWith<$Res> {
  __$$DmChannelImplCopyWithImpl(
      _$DmChannelImpl _value, $Res Function(_$DmChannelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? members = null,
    Object? unreadCount = null,
    Object? lastMessageText = freezed,
    Object? lastMessageAt = freezed,
  }) {
    return _then(_$DmChannelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<DmParticipant>,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessageText: freezed == lastMessageText
          ? _value.lastMessageText
          : lastMessageText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DmChannelImpl implements _DmChannel {
  const _$DmChannelImpl(
      {required this.id,
      required final List<DmParticipant> members,
      this.unreadCount = 0,
      this.lastMessageText,
      this.lastMessageAt})
      : _members = members;

  factory _$DmChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DmChannelImplFromJson(json);

  @override
  final String id;

  /// List of participant user objects (excluding the current user for display).
  final List<DmParticipant> _members;

  /// List of participant user objects (excluding the current user for display).
  @override
  List<DmParticipant> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  @JsonKey()
  final int unreadCount;
  @override
  final String? lastMessageText;
  @override
  final DateTime? lastMessageAt;

  @override
  String toString() {
    return 'DmChannel(id: $id, members: $members, unreadCount: $unreadCount, lastMessageText: $lastMessageText, lastMessageAt: $lastMessageAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DmChannelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageText, lastMessageText) ||
                other.lastMessageText == lastMessageText) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_members),
      unreadCount,
      lastMessageText,
      lastMessageAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DmChannelImplCopyWith<_$DmChannelImpl> get copyWith =>
      __$$DmChannelImplCopyWithImpl<_$DmChannelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DmChannelImplToJson(
      this,
    );
  }
}

abstract class _DmChannel implements DmChannel {
  const factory _DmChannel(
      {required final String id,
      required final List<DmParticipant> members,
      final int unreadCount,
      final String? lastMessageText,
      final DateTime? lastMessageAt}) = _$DmChannelImpl;

  factory _DmChannel.fromJson(Map<String, dynamic> json) =
      _$DmChannelImpl.fromJson;

  @override
  String get id;
  @override

  /// List of participant user objects (excluding the current user for display).
  List<DmParticipant> get members;
  @override
  int get unreadCount;
  @override
  String? get lastMessageText;
  @override
  DateTime? get lastMessageAt;
  @override
  @JsonKey(ignore: true)
  _$$DmChannelImplCopyWith<_$DmChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DmParticipant _$DmParticipantFromJson(Map<String, dynamic> json) {
  return _DmParticipant.fromJson(json);
}

/// @nodoc
mixin _$DmParticipant {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  UserPresence get presence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DmParticipantCopyWith<DmParticipant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DmParticipantCopyWith<$Res> {
  factory $DmParticipantCopyWith(
          DmParticipant value, $Res Function(DmParticipant) then) =
      _$DmParticipantCopyWithImpl<$Res, DmParticipant>;
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? avatarUrl,
      UserPresence presence});
}

/// @nodoc
class _$DmParticipantCopyWithImpl<$Res, $Val extends DmParticipant>
    implements $DmParticipantCopyWith<$Res> {
  _$DmParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? presence = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      presence: null == presence
          ? _value.presence
          : presence // ignore: cast_nullable_to_non_nullable
              as UserPresence,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DmParticipantImplCopyWith<$Res>
    implements $DmParticipantCopyWith<$Res> {
  factory _$$DmParticipantImplCopyWith(
          _$DmParticipantImpl value, $Res Function(_$DmParticipantImpl) then) =
      __$$DmParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String displayName,
      String? avatarUrl,
      UserPresence presence});
}

/// @nodoc
class __$$DmParticipantImplCopyWithImpl<$Res>
    extends _$DmParticipantCopyWithImpl<$Res, _$DmParticipantImpl>
    implements _$$DmParticipantImplCopyWith<$Res> {
  __$$DmParticipantImplCopyWithImpl(
      _$DmParticipantImpl _value, $Res Function(_$DmParticipantImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? presence = null,
  }) {
    return _then(_$DmParticipantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      presence: null == presence
          ? _value.presence
          : presence // ignore: cast_nullable_to_non_nullable
              as UserPresence,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DmParticipantImpl implements _DmParticipant {
  const _$DmParticipantImpl(
      {required this.id,
      required this.displayName,
      this.avatarUrl,
      this.presence = UserPresence.offline});

  factory _$DmParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$DmParticipantImplFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  @JsonKey()
  final UserPresence presence;

  @override
  String toString() {
    return 'DmParticipant(id: $id, displayName: $displayName, avatarUrl: $avatarUrl, presence: $presence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DmParticipantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.presence, presence) ||
                other.presence == presence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, displayName, avatarUrl, presence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DmParticipantImplCopyWith<_$DmParticipantImpl> get copyWith =>
      __$$DmParticipantImplCopyWithImpl<_$DmParticipantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DmParticipantImplToJson(
      this,
    );
  }
}

abstract class _DmParticipant implements DmParticipant {
  const factory _DmParticipant(
      {required final String id,
      required final String displayName,
      final String? avatarUrl,
      final UserPresence presence}) = _$DmParticipantImpl;

  factory _DmParticipant.fromJson(Map<String, dynamic> json) =
      _$DmParticipantImpl.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  UserPresence get presence;
  @override
  @JsonKey(ignore: true)
  _$$DmParticipantImplCopyWith<_$DmParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
