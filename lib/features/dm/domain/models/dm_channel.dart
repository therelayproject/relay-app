import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/models/user.dart';

part 'dm_channel.freezed.dart';
part 'dm_channel.g.dart';

/// A direct-message conversation between two or more users (DM-01/02/03).
@freezed
class DmChannel with _$DmChannel {
  const factory DmChannel({
    required String id,
    /// List of participant user objects (excluding the current user for display).
    required List<DmParticipant> members,
    @Default(0) int unreadCount,
    String? lastMessageText,
    DateTime? lastMessageAt,
  }) = _DmChannel;

  factory DmChannel.fromJson(Map<String, dynamic> json) =>
      _$DmChannelFromJson(json);
}

/// A condensed participant entry returned inside a DM channel.
@freezed
class DmParticipant with _$DmParticipant {
  const factory DmParticipant({
    required String id,
    required String displayName,
    String? avatarUrl,
    @Default(UserPresence.offline) UserPresence presence,
  }) = _DmParticipant;

  factory DmParticipant.fromJson(Map<String, dynamic> json) =>
      _$DmParticipantFromJson(json);
}
