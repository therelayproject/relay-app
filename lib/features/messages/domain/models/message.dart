import 'package:freezed_annotation/freezed_annotation.dart';

import 'reaction.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String channelId,
    required String authorId,
    required String authorName,
    String? authorAvatarUrl,
    required String text,
    required DateTime createdAt,
    DateTime? editedAt,
    DateTime? deletedAt,
    String? threadId,
    @Default(0) int replyCount,
    @Default([]) List<Reaction> reactions,
    @Default([]) List<MessageAttachment> attachments,
    @Default(false) bool isPinned,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

@freezed
class MessageAttachment with _$MessageAttachment {
  const factory MessageAttachment({
    required String id,
    required String name,
    required String mimeType,
    required String url,
    int? sizeBytes,
    int? imageWidth,
    int? imageHeight,
  }) = _MessageAttachment;

  factory MessageAttachment.fromJson(Map<String, dynamic> json) =>
      _$MessageAttachmentFromJson(json);
}
