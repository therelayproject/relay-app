// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dmChannelListHash() => r'4952f0208ffca238729bb5e298a14142353a819f';

/// All DM channels for the current user, updated via WebSocket (DM-01).
///
/// Copied from [DmChannelList].
@ProviderFor(DmChannelList)
final dmChannelListProvider =
    AutoDisposeAsyncNotifierProvider<DmChannelList, List<DmChannel>>.internal(
  DmChannelList.new,
  name: r'dmChannelListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dmChannelListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DmChannelList = AutoDisposeAsyncNotifier<List<DmChannel>>;
String _$dmMessagesHash() => r'5d8be408367de47953f6c70463f62f0d04948465';

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

abstract class _$DmMessages
    extends BuildlessAutoDisposeAsyncNotifier<List<_DmMessage>> {
  late final String dmChannelId;

  FutureOr<List<_DmMessage>> build({
    required String dmChannelId,
  });
}

/// Messages for a single DM channel — same shape as MessageListProvider.
///
/// Copied from [DmMessages].
@ProviderFor(DmMessages)
const dmMessagesProvider = DmMessagesFamily();

/// Messages for a single DM channel — same shape as MessageListProvider.
///
/// Copied from [DmMessages].
class DmMessagesFamily extends Family<AsyncValue<List<_DmMessage>>> {
  /// Messages for a single DM channel — same shape as MessageListProvider.
  ///
  /// Copied from [DmMessages].
  const DmMessagesFamily();

  /// Messages for a single DM channel — same shape as MessageListProvider.
  ///
  /// Copied from [DmMessages].
  DmMessagesProvider call({
    required String dmChannelId,
  }) {
    return DmMessagesProvider(
      dmChannelId: dmChannelId,
    );
  }

  @override
  DmMessagesProvider getProviderOverride(
    covariant DmMessagesProvider provider,
  ) {
    return call(
      dmChannelId: provider.dmChannelId,
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
  String? get name => r'dmMessagesProvider';
}

/// Messages for a single DM channel — same shape as MessageListProvider.
///
/// Copied from [DmMessages].
class DmMessagesProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DmMessages, List<_DmMessage>> {
  /// Messages for a single DM channel — same shape as MessageListProvider.
  ///
  /// Copied from [DmMessages].
  DmMessagesProvider({
    required String dmChannelId,
  }) : this._internal(
          () => DmMessages()..dmChannelId = dmChannelId,
          from: dmMessagesProvider,
          name: r'dmMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dmMessagesHash,
          dependencies: DmMessagesFamily._dependencies,
          allTransitiveDependencies:
              DmMessagesFamily._allTransitiveDependencies,
          dmChannelId: dmChannelId,
        );

  DmMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dmChannelId,
  }) : super.internal();

  final String dmChannelId;

  @override
  FutureOr<List<_DmMessage>> runNotifierBuild(
    covariant DmMessages notifier,
  ) {
    return notifier.build(
      dmChannelId: dmChannelId,
    );
  }

  @override
  Override overrideWith(DmMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: DmMessagesProvider._internal(
        () => create()..dmChannelId = dmChannelId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dmChannelId: dmChannelId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DmMessages, List<_DmMessage>>
      createElement() {
    return _DmMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DmMessagesProvider && other.dmChannelId == dmChannelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dmChannelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DmMessagesRef on AutoDisposeAsyncNotifierProviderRef<List<_DmMessage>> {
  /// The parameter `dmChannelId` of this provider.
  String get dmChannelId;
}

class _DmMessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DmMessages,
        List<_DmMessage>> with DmMessagesRef {
  _DmMessagesProviderElement(super.provider);

  @override
  String get dmChannelId => (origin as DmMessagesProvider).dmChannelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
