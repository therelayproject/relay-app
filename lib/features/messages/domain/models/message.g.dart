// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      channelId: json['channelId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      threadId: json['threadId'] as String?,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      reactions: (json['reactions'] as List<dynamic>?)
              ?.map((e) => Reaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map(
                  (e) => MessageAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isPinned: json['isPinned'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channelId': instance.channelId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'editedAt': instance.editedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'threadId': instance.threadId,
      'replyCount': instance.replyCount,
      'reactions': instance.reactions,
      'attachments': instance.attachments,
      'isPinned': instance.isPinned,
    };

_$MessageAttachmentImpl _$$MessageAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$MessageAttachmentImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
      url: json['url'] as String,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
      imageWidth: (json['imageWidth'] as num?)?.toInt(),
      imageHeight: (json['imageHeight'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MessageAttachmentImplToJson(
        _$MessageAttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mimeType': instance.mimeType,
      'url': instance.url,
      'sizeBytes': instance.sizeBytes,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
    };
