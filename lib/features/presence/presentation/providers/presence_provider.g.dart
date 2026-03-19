// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$presenceMapHash() => r'503379b2aa09c53ae7bd6b632e5656553f0b1b62';

/// Maps userId → [UserPresence].  Updated in real-time from WebSocket (PRES-01).
///
/// Copied from [PresenceMap].
@ProviderFor(PresenceMap)
final presenceMapProvider = AutoDisposeNotifierProvider<PresenceMap,
    Map<String, UserPresence>>.internal(
  PresenceMap.new,
  name: r'presenceMapProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$presenceMapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PresenceMap = AutoDisposeNotifier<Map<String, UserPresence>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
