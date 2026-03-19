// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkspaceImpl _$$WorkspaceImplFromJson(Map<String, dynamic> json) =>
    _$WorkspaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
      domain: json['domain'] as String?,
      plan: $enumDecodeNullable(_$WorkspacePlanEnumMap, json['plan']) ??
          WorkspacePlan.free,
    );

Map<String, dynamic> _$$WorkspaceImplToJson(_$WorkspaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'domain': instance.domain,
      'plan': _$WorkspacePlanEnumMap[instance.plan]!,
    };

const _$WorkspacePlanEnumMap = {
  WorkspacePlan.free: 'free',
  WorkspacePlan.pro: 'pro',
  WorkspacePlan.enterprise: 'enterprise',
};
