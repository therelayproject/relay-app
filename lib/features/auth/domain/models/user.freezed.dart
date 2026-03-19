// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get statusText => throw _privateConstructorUsedError;
  String? get statusEmoji => throw _privateConstructorUsedError;
  bool get isBot => throw _privateConstructorUsedError;
  UserPresence get presence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String? avatarUrl,
      String? statusText,
      String? statusEmoji,
      bool isBot,
      UserPresence presence});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? statusText = freezed,
    Object? statusEmoji = freezed,
    Object? isBot = null,
    Object? presence = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
      statusEmoji: freezed == statusEmoji
          ? _value.statusEmoji
          : statusEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isBot: null == isBot
          ? _value.isBot
          : isBot // ignore: cast_nullable_to_non_nullable
              as bool,
      presence: null == presence
          ? _value.presence
          : presence // ignore: cast_nullable_to_non_nullable
              as UserPresence,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String? avatarUrl,
      String? statusText,
      String? statusEmoji,
      bool isBot,
      UserPresence presence});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? avatarUrl = freezed,
    Object? statusText = freezed,
    Object? statusEmoji = freezed,
    Object? isBot = null,
    Object? presence = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      statusText: freezed == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String?,
      statusEmoji: freezed == statusEmoji
          ? _value.statusEmoji
          : statusEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isBot: null == isBot
          ? _value.isBot
          : isBot // ignore: cast_nullable_to_non_nullable
              as bool,
      presence: null == presence
          ? _value.presence
          : presence // ignore: cast_nullable_to_non_nullable
              as UserPresence,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.displayName,
      this.avatarUrl,
      this.statusText,
      this.statusEmoji,
      this.isBot = false,
      this.presence = UserPresence.offline});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final String? statusText;
  @override
  final String? statusEmoji;
  @override
  @JsonKey()
  final bool isBot;
  @override
  @JsonKey()
  final UserPresence presence;

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, avatarUrl: $avatarUrl, statusText: $statusText, statusEmoji: $statusEmoji, isBot: $isBot, presence: $presence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText) &&
            (identical(other.statusEmoji, statusEmoji) ||
                other.statusEmoji == statusEmoji) &&
            (identical(other.isBot, isBot) || other.isBot == isBot) &&
            (identical(other.presence, presence) ||
                other.presence == presence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, displayName,
      avatarUrl, statusText, statusEmoji, isBot, presence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String displayName,
      final String? avatarUrl,
      final String? statusText,
      final String? statusEmoji,
      final bool isBot,
      final UserPresence presence}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String? get avatarUrl;
  @override
  String? get statusText;
  @override
  String? get statusEmoji;
  @override
  bool get isBot;
  @override
  UserPresence get presence;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
