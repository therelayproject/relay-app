// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationCountHash() =>
    r'e0bf47ff84aef620d7c4ba43be88036b8cff259d';

/// Total count of unread notifications (NOTIF-01).
///
/// Copied from [unreadNotificationCount].
@ProviderFor(unreadNotificationCount)
final unreadNotificationCountProvider = AutoDisposeProvider<int>.internal(
  unreadNotificationCount,
  name: r'unreadNotificationCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$unreadNotificationCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UnreadNotificationCountRef = AutoDisposeProviderRef<int>;
String _$channelNotificationPrefsHash() =>
    r'9d44d14c5afd888726c4b4b0bdd2005c7c48fd06';

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

/// Per-channel notification preferences (NOTIF-02/03).
///
/// Copied from [channelNotificationPrefs].
@ProviderFor(channelNotificationPrefs)
const channelNotificationPrefsProvider = ChannelNotificationPrefsFamily();

/// Per-channel notification preferences (NOTIF-02/03).
///
/// Copied from [channelNotificationPrefs].
class ChannelNotificationPrefsFamily
    extends Family<AsyncValue<List<ChannelNotificationPrefs>>> {
  /// Per-channel notification preferences (NOTIF-02/03).
  ///
  /// Copied from [channelNotificationPrefs].
  const ChannelNotificationPrefsFamily();

  /// Per-channel notification preferences (NOTIF-02/03).
  ///
  /// Copied from [channelNotificationPrefs].
  ChannelNotificationPrefsProvider call({
    required String workspaceId,
  }) {
    return ChannelNotificationPrefsProvider(
      workspaceId: workspaceId,
    );
  }

  @override
  ChannelNotificationPrefsProvider getProviderOverride(
    covariant ChannelNotificationPrefsProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
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
  String? get name => r'channelNotificationPrefsProvider';
}

/// Per-channel notification preferences (NOTIF-02/03).
///
/// Copied from [channelNotificationPrefs].
class ChannelNotificationPrefsProvider
    extends AutoDisposeFutureProvider<List<ChannelNotificationPrefs>> {
  /// Per-channel notification preferences (NOTIF-02/03).
  ///
  /// Copied from [channelNotificationPrefs].
  ChannelNotificationPrefsProvider({
    required String workspaceId,
  }) : this._internal(
          (ref) => channelNotificationPrefs(
            ref as ChannelNotificationPrefsRef,
            workspaceId: workspaceId,
          ),
          from: channelNotificationPrefsProvider,
          name: r'channelNotificationPrefsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelNotificationPrefsHash,
          dependencies: ChannelNotificationPrefsFamily._dependencies,
          allTransitiveDependencies:
              ChannelNotificationPrefsFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
        );

  ChannelNotificationPrefsProvider._internal(
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
    FutureOr<List<ChannelNotificationPrefs>> Function(
            ChannelNotificationPrefsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChannelNotificationPrefsProvider._internal(
        (ref) => create(ref as ChannelNotificationPrefsRef),
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
  AutoDisposeFutureProviderElement<List<ChannelNotificationPrefs>>
      createElement() {
    return _ChannelNotificationPrefsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelNotificationPrefsProvider &&
        other.workspaceId == workspaceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChannelNotificationPrefsRef
    on AutoDisposeFutureProviderRef<List<ChannelNotificationPrefs>> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;
}

class _ChannelNotificationPrefsProviderElement
    extends AutoDisposeFutureProviderElement<List<ChannelNotificationPrefs>>
    with ChannelNotificationPrefsRef {
  _ChannelNotificationPrefsProviderElement(super.provider);

  @override
  String get workspaceId =>
      (origin as ChannelNotificationPrefsProvider).workspaceId;
}

String _$updateChannelNotificationPrefHash() =>
    r'72fc60a3815739f36d69cfbd0b676a5f9988976d';

/// Updates notification level for a single channel.
///
/// Copied from [updateChannelNotificationPref].
@ProviderFor(updateChannelNotificationPref)
const updateChannelNotificationPrefProvider =
    UpdateChannelNotificationPrefFamily();

/// Updates notification level for a single channel.
///
/// Copied from [updateChannelNotificationPref].
class UpdateChannelNotificationPrefFamily extends Family<AsyncValue<void>> {
  /// Updates notification level for a single channel.
  ///
  /// Copied from [updateChannelNotificationPref].
  const UpdateChannelNotificationPrefFamily();

  /// Updates notification level for a single channel.
  ///
  /// Copied from [updateChannelNotificationPref].
  UpdateChannelNotificationPrefProvider call({
    required String workspaceId,
    required String channelId,
    required String level,
  }) {
    return UpdateChannelNotificationPrefProvider(
      workspaceId: workspaceId,
      channelId: channelId,
      level: level,
    );
  }

  @override
  UpdateChannelNotificationPrefProvider getProviderOverride(
    covariant UpdateChannelNotificationPrefProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
      channelId: provider.channelId,
      level: provider.level,
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
  String? get name => r'updateChannelNotificationPrefProvider';
}

/// Updates notification level for a single channel.
///
/// Copied from [updateChannelNotificationPref].
class UpdateChannelNotificationPrefProvider
    extends AutoDisposeFutureProvider<void> {
  /// Updates notification level for a single channel.
  ///
  /// Copied from [updateChannelNotificationPref].
  UpdateChannelNotificationPrefProvider({
    required String workspaceId,
    required String channelId,
    required String level,
  }) : this._internal(
          (ref) => updateChannelNotificationPref(
            ref as UpdateChannelNotificationPrefRef,
            workspaceId: workspaceId,
            channelId: channelId,
            level: level,
          ),
          from: updateChannelNotificationPrefProvider,
          name: r'updateChannelNotificationPrefProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateChannelNotificationPrefHash,
          dependencies: UpdateChannelNotificationPrefFamily._dependencies,
          allTransitiveDependencies:
              UpdateChannelNotificationPrefFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          channelId: channelId,
          level: level,
        );

  UpdateChannelNotificationPrefProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.channelId,
    required this.level,
  }) : super.internal();

  final String workspaceId;
  final String channelId;
  final String level;

  @override
  Override overrideWith(
    FutureOr<void> Function(UpdateChannelNotificationPrefRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateChannelNotificationPrefProvider._internal(
        (ref) => create(ref as UpdateChannelNotificationPrefRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        channelId: channelId,
        level: level,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _UpdateChannelNotificationPrefProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateChannelNotificationPrefProvider &&
        other.workspaceId == workspaceId &&
        other.channelId == channelId &&
        other.level == level;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);
    hash = _SystemHash.combine(hash, level.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateChannelNotificationPrefRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `channelId` of this provider.
  String get channelId;

  /// The parameter `level` of this provider.
  String get level;
}

class _UpdateChannelNotificationPrefProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with UpdateChannelNotificationPrefRef {
  _UpdateChannelNotificationPrefProviderElement(super.provider);

  @override
  String get workspaceId =>
      (origin as UpdateChannelNotificationPrefProvider).workspaceId;
  @override
  String get channelId =>
      (origin as UpdateChannelNotificationPrefProvider).channelId;
  @override
  String get level => (origin as UpdateChannelNotificationPrefProvider).level;
}

String _$notificationListHash() => r'd3601793bea4e9f768555195d9f4c09d27a478ff';

/// Provides the current user's in-app notifications list (NOTIF-01).
///
/// Updates in real-time via WebSocket when new notifications arrive.
///
/// Copied from [NotificationList].
@ProviderFor(NotificationList)
final notificationListProvider = AutoDisposeAsyncNotifierProvider<
    NotificationList, List<AppNotification>>.internal(
  NotificationList.new,
  name: r'notificationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationList = AutoDisposeAsyncNotifier<List<AppNotification>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
