import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../domain/models/channel.dart';

part 'channels_provider.g.dart';

@riverpod
Future<List<Channel>> channelList(Ref ref, String workspaceId) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.get<List<dynamic>>(
    '/workspaces/$workspaceId/channels',
  );
  return (response.data ?? [])
      .cast<Map<String, dynamic>>()
      .map(Channel.fromJson)
      .toList();
}

@riverpod
Future<List<Channel>> publicChannelBrowser(
  Ref ref,
  String workspaceId, {
  String query = '',
}) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.get<List<dynamic>>(
    '/workspaces/$workspaceId/channels/browse',
    queryParameters: {
      if (query.isNotEmpty) 'q': query,
    },
  );
  return (response.data ?? [])
      .cast<Map<String, dynamic>>()
      .map(Channel.fromJson)
      .toList();
}

@riverpod
Future<void> joinChannel(
  Ref ref, {
  required String workspaceId,
  required String channelId,
}) async {
  final dio = ref.watch(httpClientProvider);
  await dio.post<void>('/workspaces/$workspaceId/channels/$channelId/join');
  ref.invalidate(channelListProvider(workspaceId));
}

@riverpod
Future<Channel> updateChannel(
  Ref ref, {
  required String workspaceId,
  required String channelId,
  String? channelName,
  String? topic,
  String? purpose,
}) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.patch<Map<String, dynamic>>(
    '/workspaces/$workspaceId/channels/$channelId',
    data: {
      if (channelName != null) 'name': channelName,
      if (topic != null) 'topic': topic,
      if (purpose != null) 'purpose': purpose,
    },
  );
  ref.invalidate(channelListProvider(workspaceId));
  return Channel.fromJson(response.data!);
}

@riverpod
Future<List<Map<String, dynamic>>> channelMembers(
  Ref ref, {
  required String workspaceId,
  required String channelId,
}) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.get<List<dynamic>>(
    '/workspaces/$workspaceId/channels/$channelId/members',
  );
  return (response.data ?? []).cast<Map<String, dynamic>>();
}

@riverpod
class CurrentChannel extends _$CurrentChannel {
  @override
  Channel? build() => null;

  void select(Channel channel) => state = channel;
  void clear() => state = null;
}
