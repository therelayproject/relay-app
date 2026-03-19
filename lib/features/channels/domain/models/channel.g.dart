// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelImpl _$$ChannelImplFromJson(Map<String, dynamic> json) =>
    _$ChannelImpl(
      id: json['id'] as String,
      workspaceId: json['workspaceId'] as String,
      name: json['name'] as String,
      topic: json['topic'] as String?,
      purpose: json['purpose'] as String?,
      type: $enumDecodeNullable(_$ChannelTypeEnumMap, json['type']) ??
          ChannelType.public,
      isArchived: json['isArchived'] as bool? ?? false,
      memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
    );

Map<String, dynamic> _$$ChannelImplToJson(_$ChannelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'name': instance.name,
      'topic': instance.topic,
      'purpose': instance.purpose,
      'type': _$ChannelTypeEnumMap[instance.type]!,
      'isArchived': instance.isArchived,
      'memberCount': instance.memberCount,
      'unreadCount': instance.unreadCount,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
    };

const _$ChannelTypeEnumMap = {
  ChannelType.public: 'public',
  ChannelType.private: 'private',
};
