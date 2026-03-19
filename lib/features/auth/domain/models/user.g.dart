// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      statusText: json['statusText'] as String?,
      statusEmoji: json['statusEmoji'] as String?,
      isBot: json['isBot'] as bool? ?? false,
      presence: $enumDecodeNullable(_$UserPresenceEnumMap, json['presence']) ??
          UserPresence.offline,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'avatarUrl': instance.avatarUrl,
      'statusText': instance.statusText,
      'statusEmoji': instance.statusEmoji,
      'isBot': instance.isBot,
      'presence': _$UserPresenceEnumMap[instance.presence]!,
    };

const _$UserPresenceEnumMap = {
  UserPresence.online: 'online',
  UserPresence.away: 'away',
  UserPresence.dnd: 'dnd',
  UserPresence.offline: 'offline',
};
