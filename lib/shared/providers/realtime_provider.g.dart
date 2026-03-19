// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$realtimeSessionHash() => r'fec26dbf1aa1d0a66ab08c634549b71c08eb09a6';

/// Manages the WebSocket lifecycle tied to auth state.
/// Connects on login, disconnects on logout.
///
/// Copied from [RealtimeSession].
@ProviderFor(RealtimeSession)
final realtimeSessionProvider =
    AutoDisposeNotifierProvider<RealtimeSession, WsConnectionState>.internal(
  RealtimeSession.new,
  name: r'realtimeSessionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$realtimeSessionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RealtimeSession = AutoDisposeNotifier<WsConnectionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
