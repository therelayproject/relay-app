// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channels_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelListHash() => r'6f37c77368aaf097576357cab552ccaf07e094ab';

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

/// See also [channelList].
@ProviderFor(channelList)
const channelListProvider = ChannelListFamily();

/// See also [channelList].
class ChannelListFamily extends Family<AsyncValue<List<Channel>>> {
  /// See also [channelList].
  const ChannelListFamily();

  /// See also [channelList].
  ChannelListProvider call(
    String workspaceId,
  ) {
    return ChannelListProvider(
      workspaceId,
    );
  }

  @override
  ChannelListProvider getProviderOverride(
    covariant ChannelListProvider provider,
  ) {
    return call(
      provider.workspaceId,
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
  String? get name => r'channelListProvider';
}

/// See also [channelList].
class ChannelListProvider extends AutoDisposeFutureProvider<List<Channel>> {
  /// See also [channelList].
  ChannelListProvider(
    String workspaceId,
  ) : this._internal(
          (ref) => channelList(
            ref as ChannelListRef,
            workspaceId,
          ),
          from: channelListProvider,
          name: r'channelListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelListHash,
          dependencies: ChannelListFamily._dependencies,
          allTransitiveDependencies:
              ChannelListFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
        );

  ChannelListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
  }) : super.internal();

  final String workspaceId;

  @override
  Override overrideWith(
    FutureOr<List<Channel>> Function(ChannelListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChannelListProvider._internal(
        (ref) => create(ref as ChannelListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Channel>> createElement() {
    return _ChannelListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelListProvider && other.workspaceId == workspaceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChannelListRef on AutoDisposeFutureProviderRef<List<Channel>> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;
}

class _ChannelListProviderElement
    extends AutoDisposeFutureProviderElement<List<Channel>>
    with ChannelListRef {
  _ChannelListProviderElement(super.provider);

  @override
  String get workspaceId => (origin as ChannelListProvider).workspaceId;
}

String _$publicChannelBrowserHash() =>
    r'd3b9737c4f3f9e2b058e71b68ec4307d5e000ed1';

/// See also [publicChannelBrowser].
@ProviderFor(publicChannelBrowser)
const publicChannelBrowserProvider = PublicChannelBrowserFamily();

/// See also [publicChannelBrowser].
class PublicChannelBrowserFamily extends Family<AsyncValue<List<Channel>>> {
  /// See also [publicChannelBrowser].
  const PublicChannelBrowserFamily();

  /// See also [publicChannelBrowser].
  PublicChannelBrowserProvider call(
    String workspaceId, {
    String query = '',
  }) {
    return PublicChannelBrowserProvider(
      workspaceId,
      query: query,
    );
  }

  @override
  PublicChannelBrowserProvider getProviderOverride(
    covariant PublicChannelBrowserProvider provider,
  ) {
    return call(
      provider.workspaceId,
      query: provider.query,
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
  String? get name => r'publicChannelBrowserProvider';
}

/// See also [publicChannelBrowser].
class PublicChannelBrowserProvider
    extends AutoDisposeFutureProvider<List<Channel>> {
  /// See also [publicChannelBrowser].
  PublicChannelBrowserProvider(
    String workspaceId, {
    String query = '',
  }) : this._internal(
          (ref) => publicChannelBrowser(
            ref as PublicChannelBrowserRef,
            workspaceId,
            query: query,
          ),
          from: publicChannelBrowserProvider,
          name: r'publicChannelBrowserProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$publicChannelBrowserHash,
          dependencies: PublicChannelBrowserFamily._dependencies,
          allTransitiveDependencies:
              PublicChannelBrowserFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          query: query,
        );

  PublicChannelBrowserProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.query,
  }) : super.internal();

  final String workspaceId;
  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Channel>> Function(PublicChannelBrowserRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PublicChannelBrowserProvider._internal(
        (ref) => create(ref as PublicChannelBrowserRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Channel>> createElement() {
    return _PublicChannelBrowserProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicChannelBrowserProvider &&
        other.workspaceId == workspaceId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin PublicChannelBrowserRef on AutoDisposeFutureProviderRef<List<Channel>> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `query` of this provider.
  String get query;
}

class _PublicChannelBrowserProviderElement
    extends AutoDisposeFutureProviderElement<List<Channel>>
    with PublicChannelBrowserRef {
  _PublicChannelBrowserProviderElement(super.provider);

  @override
  String get workspaceId =>
      (origin as PublicChannelBrowserProvider).workspaceId;
  @override
  String get query => (origin as PublicChannelBrowserProvider).query;
}

String _$joinChannelHash() => r'744a568f20f68e6554af0f3a31c340b51b0629a0';

/// See also [joinChannel].
@ProviderFor(joinChannel)
const joinChannelProvider = JoinChannelFamily();

/// See also [joinChannel].
class JoinChannelFamily extends Family<AsyncValue<void>> {
  /// See also [joinChannel].
  const JoinChannelFamily();

  /// See also [joinChannel].
  JoinChannelProvider call({
    required String workspaceId,
    required String channelId,
  }) {
    return JoinChannelProvider(
      workspaceId: workspaceId,
      channelId: channelId,
    );
  }

  @override
  JoinChannelProvider getProviderOverride(
    covariant JoinChannelProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
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
  String? get name => r'joinChannelProvider';
}

/// See also [joinChannel].
class JoinChannelProvider extends AutoDisposeFutureProvider<void> {
  /// See also [joinChannel].
  JoinChannelProvider({
    required String workspaceId,
    required String channelId,
  }) : this._internal(
          (ref) => joinChannel(
            ref as JoinChannelRef,
            workspaceId: workspaceId,
            channelId: channelId,
          ),
          from: joinChannelProvider,
          name: r'joinChannelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$joinChannelHash,
          dependencies: JoinChannelFamily._dependencies,
          allTransitiveDependencies:
              JoinChannelFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          channelId: channelId,
        );

  JoinChannelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.channelId,
  }) : super.internal();

  final String workspaceId;
  final String channelId;

  @override
  Override overrideWith(
    FutureOr<void> Function(JoinChannelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JoinChannelProvider._internal(
        (ref) => create(ref as JoinChannelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        channelId: channelId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _JoinChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JoinChannelProvider &&
        other.workspaceId == workspaceId &&
        other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JoinChannelRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _JoinChannelProviderElement extends AutoDisposeFutureProviderElement<void>
    with JoinChannelRef {
  _JoinChannelProviderElement(super.provider);

  @override
  String get workspaceId => (origin as JoinChannelProvider).workspaceId;
  @override
  String get channelId => (origin as JoinChannelProvider).channelId;
}

String _$updateChannelHash() => r'e99be21b7f5715899e1927625689761b99598b96';

/// See also [updateChannel].
@ProviderFor(updateChannel)
const updateChannelProvider = UpdateChannelFamily();

/// See also [updateChannel].
class UpdateChannelFamily extends Family<AsyncValue<Channel>> {
  /// See also [updateChannel].
  const UpdateChannelFamily();

  /// See also [updateChannel].
  UpdateChannelProvider call({
    required String workspaceId,
    required String channelId,
    String? channelName,
    String? topic,
    String? purpose,
  }) {
    return UpdateChannelProvider(
      workspaceId: workspaceId,
      channelId: channelId,
      channelName: channelName,
      topic: topic,
      purpose: purpose,
    );
  }

  @override
  UpdateChannelProvider getProviderOverride(
    covariant UpdateChannelProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
      channelId: provider.channelId,
      channelName: provider.channelName,
      topic: provider.topic,
      purpose: provider.purpose,
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
  String? get name => r'updateChannelProvider';
}

/// See also [updateChannel].
class UpdateChannelProvider extends AutoDisposeFutureProvider<Channel> {
  /// See also [updateChannel].
  UpdateChannelProvider({
    required String workspaceId,
    required String channelId,
    String? channelName,
    String? topic,
    String? purpose,
  }) : this._internal(
          (ref) => updateChannel(
            ref as UpdateChannelRef,
            workspaceId: workspaceId,
            channelId: channelId,
            channelName: channelName,
            topic: topic,
            purpose: purpose,
          ),
          from: updateChannelProvider,
          name: r'updateChannelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateChannelHash,
          dependencies: UpdateChannelFamily._dependencies,
          allTransitiveDependencies:
              UpdateChannelFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          channelId: channelId,
          channelName: channelName,
          topic: topic,
          purpose: purpose,
        );

  UpdateChannelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.channelId,
    required this.channelName,
    required this.topic,
    required this.purpose,
  }) : super.internal();

  final String workspaceId;
  final String channelId;
  final String? channelName;
  final String? topic;
  final String? purpose;

  @override
  Override overrideWith(
    FutureOr<Channel> Function(UpdateChannelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateChannelProvider._internal(
        (ref) => create(ref as UpdateChannelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        channelId: channelId,
        channelName: channelName,
        topic: topic,
        purpose: purpose,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Channel> createElement() {
    return _UpdateChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateChannelProvider &&
        other.workspaceId == workspaceId &&
        other.channelId == channelId &&
        other.channelName == channelName &&
        other.topic == topic &&
        other.purpose == purpose;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);
    hash = _SystemHash.combine(hash, channelName.hashCode);
    hash = _SystemHash.combine(hash, topic.hashCode);
    hash = _SystemHash.combine(hash, purpose.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateChannelRef on AutoDisposeFutureProviderRef<Channel> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `channelId` of this provider.
  String get channelId;

  /// The parameter `channelName` of this provider.
  String? get channelName;

  /// The parameter `topic` of this provider.
  String? get topic;

  /// The parameter `purpose` of this provider.
  String? get purpose;
}

class _UpdateChannelProviderElement
    extends AutoDisposeFutureProviderElement<Channel> with UpdateChannelRef {
  _UpdateChannelProviderElement(super.provider);

  @override
  String get workspaceId => (origin as UpdateChannelProvider).workspaceId;
  @override
  String get channelId => (origin as UpdateChannelProvider).channelId;
  @override
  String? get channelName => (origin as UpdateChannelProvider).channelName;
  @override
  String? get topic => (origin as UpdateChannelProvider).topic;
  @override
  String? get purpose => (origin as UpdateChannelProvider).purpose;
}

String _$channelMembersHash() => r'59498d2fb5a119f57ae5cf278289584b4ff8ff31';

/// See also [channelMembers].
@ProviderFor(channelMembers)
const channelMembersProvider = ChannelMembersFamily();

/// See also [channelMembers].
class ChannelMembersFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [channelMembers].
  const ChannelMembersFamily();

  /// See also [channelMembers].
  ChannelMembersProvider call({
    required String workspaceId,
    required String channelId,
  }) {
    return ChannelMembersProvider(
      workspaceId: workspaceId,
      channelId: channelId,
    );
  }

  @override
  ChannelMembersProvider getProviderOverride(
    covariant ChannelMembersProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
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
  String? get name => r'channelMembersProvider';
}

/// See also [channelMembers].
class ChannelMembersProvider
    extends AutoDisposeFutureProvider<List<Map<String, dynamic>>> {
  /// See also [channelMembers].
  ChannelMembersProvider({
    required String workspaceId,
    required String channelId,
  }) : this._internal(
          (ref) => channelMembers(
            ref as ChannelMembersRef,
            workspaceId: workspaceId,
            channelId: channelId,
          ),
          from: channelMembersProvider,
          name: r'channelMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelMembersHash,
          dependencies: ChannelMembersFamily._dependencies,
          allTransitiveDependencies:
              ChannelMembersFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          channelId: channelId,
        );

  ChannelMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.channelId,
  }) : super.internal();

  final String workspaceId;
  final String channelId;

  @override
  Override overrideWith(
    FutureOr<List<Map<String, dynamic>>> Function(ChannelMembersRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChannelMembersProvider._internal(
        (ref) => create(ref as ChannelMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        channelId: channelId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Map<String, dynamic>>> createElement() {
    return _ChannelMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelMembersProvider &&
        other.workspaceId == workspaceId &&
        other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChannelMembersRef
    on AutoDisposeFutureProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _ChannelMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<Map<String, dynamic>>>
    with ChannelMembersRef {
  _ChannelMembersProviderElement(super.provider);

  @override
  String get workspaceId => (origin as ChannelMembersProvider).workspaceId;
  @override
  String get channelId => (origin as ChannelMembersProvider).channelId;
}

String _$currentChannelHash() => r'd0a6cde58c4cc9bec0fea091f06cd1284c6de37e';

/// See also [CurrentChannel].
@ProviderFor(CurrentChannel)
final currentChannelProvider =
    AutoDisposeNotifierProvider<CurrentChannel, Channel?>.internal(
  CurrentChannel.new,
  name: r'currentChannelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentChannelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentChannel = AutoDisposeNotifier<Channel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
