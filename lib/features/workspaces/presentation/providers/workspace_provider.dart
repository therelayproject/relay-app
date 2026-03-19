import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../domain/models/workspace.dart';

part 'workspace_provider.g.dart';

@riverpod
Future<List<Workspace>> workspaceList(Ref ref) async {
  final dio = ref.watch(httpClientProvider);
  final response =
      await dio.get<List<dynamic>>('/workspaces');
  return (response.data ?? [])
      .cast<Map<String, dynamic>>()
      .map(Workspace.fromJson)
      .toList();
}

@riverpod
class CurrentWorkspace extends _$CurrentWorkspace {
  @override
  Workspace? build() => null;

  void select(Workspace workspace) => state = workspace;
}

@riverpod
Future<Workspace> createWorkspace(
  Ref ref, {
  required String workspaceName,
  String? domain,
}) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.post<Map<String, dynamic>>(
    '/workspaces',
    data: {'name': workspaceName, if (domain != null) 'domain': domain},
  );
  final workspace = Workspace.fromJson(response.data!);
  ref.invalidate(workspaceListProvider);
  return workspace;
}

@riverpod
Future<Workspace> updateWorkspace(
  Ref ref, {
  required String workspaceId,
  String? workspaceName,
  String? domain,
}) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.patch<Map<String, dynamic>>(
    '/workspaces/$workspaceId',
    data: {
      if (workspaceName != null) 'name': workspaceName,
      if (domain != null) 'domain': domain,
    },
  );
  final workspace = Workspace.fromJson(response.data!);
  ref.invalidate(workspaceListProvider);
  return workspace;
}

@riverpod
Future<void> sendInvite(
  Ref ref, {
  required String workspaceId,
  required String email,
}) async {
  final dio = ref.watch(httpClientProvider);
  await dio.post<void>(
    '/workspaces/$workspaceId/invites',
    data: {'email': email},
  );
}

@riverpod
Future<String> workspaceInviteLink(Ref ref, String workspaceId) async {
  final dio = ref.watch(httpClientProvider);
  final response = await dio.post<Map<String, dynamic>>(
    '/workspaces/$workspaceId/invites/link',
  );
  return response.data!['link'] as String;
}
