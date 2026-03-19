// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactionImpl _$$ReactionImplFromJson(Map<String, dynamic> json) =>
    _$ReactionImpl(
      emoji: json['emoji'] as String,
      count: (json['count'] as num).toInt(),
      userIds: (json['userIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReactionImplToJson(_$ReactionImpl instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'count': instance.count,
      'userIds': instance.userIds,
    };
