// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String? get authorAvatarUrl => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get editedAt => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get threadId => throw _privateConstructorUsedError;
  int get replyCount => throw _privateConstructorUsedError;
  List<Reaction> get reactions => throw _privateConstructorUsedError;
  List<MessageAttachment> get attachments => throw _privateConstructorUsedError;
  bool get isPinned => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String channelId,
      String authorId,
      String authorName,
      String? authorAvatarUrl,
      String text,
      DateTime createdAt,
      DateTime? editedAt,
      DateTime? deletedAt,
      String? threadId,
      int replyCount,
      List<Reaction> reactions,
      List<MessageAttachment> attachments,
      bool isPinned});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? channelId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatarUrl = freezed,
    Object? text = null,
    Object? createdAt = null,
    Object? editedAt = freezed,
    Object? deletedAt = freezed,
    Object? threadId = freezed,
    Object? replyCount = null,
    Object? reactions = null,
    Object? attachments = null,
    Object? isPinned = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      threadId: freezed == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<Reaction>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<MessageAttachment>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String channelId,
      String authorId,
      String authorName,
      String? authorAvatarUrl,
      String text,
      DateTime createdAt,
      DateTime? editedAt,
      DateTime? deletedAt,
      String? threadId,
      int replyCount,
      List<Reaction> reactions,
      List<MessageAttachment> attachments,
      bool isPinned});
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? channelId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorAvatarUrl = freezed,
    Object? text = null,
    Object? createdAt = null,
    Object? editedAt = freezed,
    Object? deletedAt = freezed,
    Object? threadId = freezed,
    Object? replyCount = null,
    Object? reactions = null,
    Object? attachments = null,
    Object? isPinned = null,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      editedAt: freezed == editedAt
          ? _value.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      threadId: freezed == threadId
          ? _value.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String?,
      replyCount: null == replyCount
          ? _value.replyCount
          : replyCount // ignore: cast_nullable_to_non_nullable
              as int,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<Reaction>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<MessageAttachment>,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.channelId,
      required this.authorId,
      required this.authorName,
      this.authorAvatarUrl,
      required this.text,
      required this.createdAt,
      this.editedAt,
      this.deletedAt,
      this.threadId,
      this.replyCount = 0,
      final List<Reaction> reactions = const [],
      final List<MessageAttachment> attachments = const [],
      this.isPinned = false})
      : _reactions = reactions,
        _attachments = attachments;

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final String channelId;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String? authorAvatarUrl;
  @override
  final String text;
  @override
  final DateTime createdAt;
  @override
  final DateTime? editedAt;
  @override
  final DateTime? deletedAt;
  @override
  final String? threadId;
  @override
  @JsonKey()
  final int replyCount;
  final List<Reaction> _reactions;
  @override
  @JsonKey()
  List<Reaction> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  final List<MessageAttachment> _attachments;
  @override
  @JsonKey()
  List<MessageAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  @override
  @JsonKey()
  final bool isPinned;

  @override
  String toString() {
    return 'Message(id: $id, channelId: $channelId, authorId: $authorId, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, text: $text, createdAt: $createdAt, editedAt: $editedAt, deletedAt: $deletedAt, threadId: $threadId, replyCount: $replyCount, reactions: $reactions, attachments: $attachments, isPinned: $isPinned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorAvatarUrl, authorAvatarUrl) ||
                other.authorAvatarUrl == authorAvatarUrl) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      channelId,
      authorId,
      authorName,
      authorAvatarUrl,
      text,
      createdAt,
      editedAt,
      deletedAt,
      threadId,
      replyCount,
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_attachments),
      isPinned);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final String channelId,
      required final String authorId,
      required final String authorName,
      final String? authorAvatarUrl,
      required final String text,
      required final DateTime createdAt,
      final DateTime? editedAt,
      final DateTime? deletedAt,
      final String? threadId,
      final int replyCount,
      final List<Reaction> reactions,
      final List<MessageAttachment> attachments,
      final bool isPinned}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get channelId;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String? get authorAvatarUrl;
  @override
  String get text;
  @override
  DateTime get createdAt;
  @override
  DateTime? get editedAt;
  @override
  DateTime? get deletedAt;
  @override
  String? get threadId;
  @override
  int get replyCount;
  @override
  List<Reaction> get reactions;
  @override
  List<MessageAttachment> get attachments;
  @override
  bool get isPinned;
  @override
  @JsonKey(ignore: true)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageAttachment _$MessageAttachmentFromJson(Map<String, dynamic> json) {
  return _MessageAttachment.fromJson(json);
}

/// @nodoc
mixin _$MessageAttachment {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int? get sizeBytes => throw _privateConstructorUsedError;
  int? get imageWidth => throw _privateConstructorUsedError;
  int? get imageHeight => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageAttachmentCopyWith<MessageAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageAttachmentCopyWith<$Res> {
  factory $MessageAttachmentCopyWith(
          MessageAttachment value, $Res Function(MessageAttachment) then) =
      _$MessageAttachmentCopyWithImpl<$Res, MessageAttachment>;
  @useResult
  $Res call(
      {String id,
      String name,
      String mimeType,
      String url,
      int? sizeBytes,
      int? imageWidth,
      int? imageHeight});
}

/// @nodoc
class _$MessageAttachmentCopyWithImpl<$Res, $Val extends MessageAttachment>
    implements $MessageAttachmentCopyWith<$Res> {
  _$MessageAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? mimeType = null,
    Object? url = null,
    Object? sizeBytes = freezed,
    Object? imageWidth = freezed,
    Object? imageHeight = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      imageWidth: freezed == imageWidth
          ? _value.imageWidth
          : imageWidth // ignore: cast_nullable_to_non_nullable
              as int?,
      imageHeight: freezed == imageHeight
          ? _value.imageHeight
          : imageHeight // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageAttachmentImplCopyWith<$Res>
    implements $MessageAttachmentCopyWith<$Res> {
  factory _$$MessageAttachmentImplCopyWith(_$MessageAttachmentImpl value,
          $Res Function(_$MessageAttachmentImpl) then) =
      __$$MessageAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String mimeType,
      String url,
      int? sizeBytes,
      int? imageWidth,
      int? imageHeight});
}

/// @nodoc
class __$$MessageAttachmentImplCopyWithImpl<$Res>
    extends _$MessageAttachmentCopyWithImpl<$Res, _$MessageAttachmentImpl>
    implements _$$MessageAttachmentImplCopyWith<$Res> {
  __$$MessageAttachmentImplCopyWithImpl(_$MessageAttachmentImpl _value,
      $Res Function(_$MessageAttachmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? mimeType = null,
    Object? url = null,
    Object? sizeBytes = freezed,
    Object? imageWidth = freezed,
    Object? imageHeight = freezed,
  }) {
    return _then(_$MessageAttachmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: freezed == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int?,
      imageWidth: freezed == imageWidth
          ? _value.imageWidth
          : imageWidth // ignore: cast_nullable_to_non_nullable
              as int?,
      imageHeight: freezed == imageHeight
          ? _value.imageHeight
          : imageHeight // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageAttachmentImpl implements _MessageAttachment {
  const _$MessageAttachmentImpl(
      {required this.id,
      required this.name,
      required this.mimeType,
      required this.url,
      this.sizeBytes,
      this.imageWidth,
      this.imageHeight});

  factory _$MessageAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageAttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String mimeType;
  @override
  final String url;
  @override
  final int? sizeBytes;
  @override
  final int? imageWidth;
  @override
  final int? imageHeight;

  @override
  String toString() {
    return 'MessageAttachment(id: $id, name: $name, mimeType: $mimeType, url: $url, sizeBytes: $sizeBytes, imageWidth: $imageWidth, imageHeight: $imageHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.imageWidth, imageWidth) ||
                other.imageWidth == imageWidth) &&
            (identical(other.imageHeight, imageHeight) ||
                other.imageHeight == imageHeight));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, mimeType, url, sizeBytes, imageWidth, imageHeight);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageAttachmentImplCopyWith<_$MessageAttachmentImpl> get copyWith =>
      __$$MessageAttachmentImplCopyWithImpl<_$MessageAttachmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageAttachmentImplToJson(
      this,
    );
  }
}

abstract class _MessageAttachment implements MessageAttachment {
  const factory _MessageAttachment(
      {required final String id,
      required final String name,
      required final String mimeType,
      required final String url,
      final int? sizeBytes,
      final int? imageWidth,
      final int? imageHeight}) = _$MessageAttachmentImpl;

  factory _MessageAttachment.fromJson(Map<String, dynamic> json) =
      _$MessageAttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get mimeType;
  @override
  String get url;
  @override
  int? get sizeBytes;
  @override
  int? get imageWidth;
  @override
  int? get imageHeight;
  @override
  @JsonKey(ignore: true)
  _$$MessageAttachmentImplCopyWith<_$MessageAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
