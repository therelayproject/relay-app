// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dm_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DmChannelImpl _$$DmChannelImplFromJson(Map<String, dynamic> json) =>
    _$DmChannelImpl(
      id: json['id'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => DmParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageText: json['lastMessageText'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
    );

Map<String, dynamic> _$$DmChannelImplToJson(_$DmChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'members': instance.members,
      'unreadCount': instance.unreadCount,
      'lastMessageText': instance.lastMessageText,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
    };

_$DmParticipantImpl _$$DmParticipantImplFromJson(Map<String, dynamic> json) =>
    _$DmParticipantImpl(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      presence: $enumDecodeNullable(_$UserPresenceEnumMap, json['presence']) ??
          UserPresence.offline,
    );

Map<String, dynamic> _$$DmParticipantImplToJson(_$DmParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'presence': _$UserPresenceEnumMap[instance.presence]!,
    };

const _$UserPresenceEnumMap = {
  UserPresence.online: 'online',
  UserPresence.away: 'away',
  UserPresence.dnd: 'dnd',
  UserPresence.offline: 'offline',
};
