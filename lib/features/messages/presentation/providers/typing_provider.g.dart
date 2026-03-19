// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$typingUsersHash() => r'c0a5c7cc2a6f528b061cdc431b6776e91ce52bc4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TypingUsers
    extends BuildlessAutoDisposeNotifier<List<String>> {
  late final String channelId;

  List<String> build({
    required String channelId,
  });
}

/// Tracks which users are currently typing in a given channel (PRES-02).
///
/// Listens to `user.typing` WebSocket events and expires entries after 4 s of
/// inactivity (the server re-sends the event every ~2 s while a user types).
///
/// Copied from [TypingUsers].
@ProviderFor(TypingUsers)
const typingUsersProvider = TypingUsersFamily();

/// Tracks which users are currently typing in a given channel (PRES-02).
///
/// Listens to `user.typing` WebSocket events and expires entries after 4 s of
/// inactivity (the server re-sends the event every ~2 s while a user types).
///
/// Copied from [TypingUsers].
class TypingUsersFamily extends Family<List<String>> {
  /// Tracks which users are currently typing in a given channel (PRES-02).
  ///
  /// Listens to `user.typing` WebSocket events and expires entries after 4 s of
  /// inactivity (the server re-sends the event every ~2 s while a user types).
  ///
  /// Copied from [TypingUsers].
  const TypingUsersFamily();

  /// Tracks which users are currently typing in a given channel (PRES-02).
  ///
  /// Listens to `user.typing` WebSocket events and expires entries after 4 s of
  /// inactivity (the server re-sends the event every ~2 s while a user types).
  ///
  /// Copied from [TypingUsers].
  TypingUsersProvider call({
    required String channelId,
  }) {
    return TypingUsersProvider(
      channelId: channelId,
    );
  }

  @override
  TypingUsersProvider getProviderOverride(
    covariant TypingUsersProvider provider,
  ) {
    return call(
      channelId: provider.channelId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'typingUsersProvider';
}

/// Tracks which users are currently typing in a given channel (PRES-02).
///
/// Listens to `user.typing` WebSocket events and expires entries after 4 s of
/// inactivity (the server re-sends the event every ~2 s while a user types).
///
/// Copied from [TypingUsers].
class TypingUsersProvider
    extends AutoDisposeNotifierProviderImpl<TypingUsers, List<String>> {
  /// Tracks which users are currently typing in a given channel (PRES-02).
  ///
  /// Listens to `user.typing` WebSocket events and expires entries after 4 s of
  /// inactivity (the server re-sends the event every ~2 s while a user types).
  ///
  /// Copied from [TypingUsers].
  TypingUsersProvider({
    required String channelId,
  }) : this._internal(
          () => TypingUsers()..channelId = channelId,
          from: typingUsersProvider,
          name: r'typingUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$typingUsersHash,
          dependencies: TypingUsersFamily._dependencies,
          allTransitiveDependencies:
              TypingUsersFamily._allTransitiveDependencies,
          channelId: channelId,
        );

  TypingUsersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelId,
  }) : super.internal();

  final String channelId;

  @override
  List<String> runNotifierBuild(
    covariant TypingUsers notifier,
  ) {
    return notifier.build(
      channelId: channelId,
    );
  }

  @override
  Override overrideWith(TypingUsers Function() create) {
    return ProviderOverride(
      origin: this,
      override: TypingUsersProvider._internal(
        () => create()..channelId = channelId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelId: channelId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TypingUsers, List<String>>
      createElement() {
    return _TypingUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TypingUsersProvider && other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TypingUsersRef on AutoDisposeNotifierProviderRef<List<String>> {
  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _TypingUsersProviderElement
    extends AutoDisposeNotifierProviderElement<TypingUsers, List<String>>
    with TypingUsersRef {
  _TypingUsersProviderElement(super.provider);

  @override
  String get channelId => (origin as TypingUsersProvider).channelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
