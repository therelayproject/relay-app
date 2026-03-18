import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

@freezed
class Channel with _$Channel {
  const factory Channel({
    required String id,
    required String workspaceId,
    required String name,
    String? topic,
    String? purpose,
    @Default(ChannelType.public) ChannelType type,
    @Default(false) bool isArchived,
    @Default(0) int memberCount,
    @Default(0) int unreadCount,
    DateTime? lastMessageAt,
  }) = _Channel;

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}

enum ChannelType { public, private }
