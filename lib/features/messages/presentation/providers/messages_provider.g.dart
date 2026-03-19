// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$messageListHash() => r'f528ce604b434a33ed1ac65cacd015a91d20cd08';

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

abstract class _$MessageList
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final String channelId;

  FutureOr<List<Message>> build({
    required String channelId,
  });
}

/// Provides a live message list for [channelId] backed by the REST API
/// with WebSocket updates applied on top.
///
/// Copied from [MessageList].
@ProviderFor(MessageList)
const messageListProvider = MessageListFamily();

/// Provides a live message list for [channelId] backed by the REST API
/// with WebSocket updates applied on top.
///
/// Copied from [MessageList].
class MessageListFamily extends Family<AsyncValue<List<Message>>> {
  /// Provides a live message list for [channelId] backed by the REST API
  /// with WebSocket updates applied on top.
  ///
  /// Copied from [MessageList].
  const MessageListFamily();

  /// Provides a live message list for [channelId] backed by the REST API
  /// with WebSocket updates applied on top.
  ///
  /// Copied from [MessageList].
  MessageListProvider call({
    required String channelId,
  }) {
    return MessageListProvider(
      channelId: channelId,
    );
  }

  @override
  MessageListProvider getProviderOverride(
    covariant MessageListProvider provider,
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
  String? get name => r'messageListProvider';
}

/// Provides a live message list for [channelId] backed by the REST API
/// with WebSocket updates applied on top.
///
/// Copied from [MessageList].
class MessageListProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MessageList, List<Message>> {
  /// Provides a live message list for [channelId] backed by the REST API
  /// with WebSocket updates applied on top.
  ///
  /// Copied from [MessageList].
  MessageListProvider({
    required String channelId,
  }) : this._internal(
          () => MessageList()..channelId = channelId,
          from: messageListProvider,
          name: r'messageListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageListHash,
          dependencies: MessageListFamily._dependencies,
          allTransitiveDependencies:
              MessageListFamily._allTransitiveDependencies,
          channelId: channelId,
        );

  MessageListProvider._internal(
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
  FutureOr<List<Message>> runNotifierBuild(
    covariant MessageList notifier,
  ) {
    return notifier.build(
      channelId: channelId,
    );
  }

  @override
  Override overrideWith(MessageList Function() create) {
    return ProviderOverride(
      origin: this,
      override: MessageListProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MessageList, List<Message>>
      createElement() {
    return _MessageListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageListProvider && other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessageListRef on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `channelId` of this provider.
  String get channelId;
}

class _MessageListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MessageList, List<Message>>
    with MessageListRef {
  _MessageListProviderElement(super.provider);

  @override
  String get channelId => (origin as MessageListProvider).channelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
