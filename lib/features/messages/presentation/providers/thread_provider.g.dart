// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$threadMessagesHash() => r'fa1bb8b62ab9e1a71df0ef26385a9da1716d3bf6';

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

abstract class _$ThreadMessages
    extends BuildlessAutoDisposeAsyncNotifier<List<Message>> {
  late final String threadId;

  FutureOr<List<Message>> build({
    required String threadId,
  });
}

/// Provides the reply list for a given thread (parent message).
///
/// Backs ThreadPanelScreen (THR-01/02/03).
///
/// Copied from [ThreadMessages].
@ProviderFor(ThreadMessages)
const threadMessagesProvider = ThreadMessagesFamily();

/// Provides the reply list for a given thread (parent message).
///
/// Backs ThreadPanelScreen (THR-01/02/03).
///
/// Copied from [ThreadMessages].
class ThreadMessagesFamily extends Family<AsyncValue<List<Message>>> {
  /// Provides the reply list for a given thread (parent message).
  ///
  /// Backs ThreadPanelScreen (THR-01/02/03).
  ///
  /// Copied from [ThreadMessages].
  const ThreadMessagesFamily();

  /// Provides the reply list for a given thread (parent message).
  ///
  /// Backs ThreadPanelScreen (THR-01/02/03).
  ///
  /// Copied from [ThreadMessages].
  ThreadMessagesProvider call({
    required String threadId,
  }) {
    return ThreadMessagesProvider(
      threadId: threadId,
    );
  }

  @override
  ThreadMessagesProvider getProviderOverride(
    covariant ThreadMessagesProvider provider,
  ) {
    return call(
      threadId: provider.threadId,
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
  String? get name => r'threadMessagesProvider';
}

/// Provides the reply list for a given thread (parent message).
///
/// Backs ThreadPanelScreen (THR-01/02/03).
///
/// Copied from [ThreadMessages].
class ThreadMessagesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ThreadMessages, List<Message>> {
  /// Provides the reply list for a given thread (parent message).
  ///
  /// Backs ThreadPanelScreen (THR-01/02/03).
  ///
  /// Copied from [ThreadMessages].
  ThreadMessagesProvider({
    required String threadId,
  }) : this._internal(
          () => ThreadMessages()..threadId = threadId,
          from: threadMessagesProvider,
          name: r'threadMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$threadMessagesHash,
          dependencies: ThreadMessagesFamily._dependencies,
          allTransitiveDependencies:
              ThreadMessagesFamily._allTransitiveDependencies,
          threadId: threadId,
        );

  ThreadMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.threadId,
  }) : super.internal();

  final String threadId;

  @override
  FutureOr<List<Message>> runNotifierBuild(
    covariant ThreadMessages notifier,
  ) {
    return notifier.build(
      threadId: threadId,
    );
  }

  @override
  Override overrideWith(ThreadMessages Function() create) {
    return ProviderOverride(
      origin: this,
      override: ThreadMessagesProvider._internal(
        () => create()..threadId = threadId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        threadId: threadId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ThreadMessages, List<Message>>
      createElement() {
    return _ThreadMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ThreadMessagesProvider && other.threadId == threadId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, threadId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ThreadMessagesRef on AutoDisposeAsyncNotifierProviderRef<List<Message>> {
  /// The parameter `threadId` of this provider.
  String get threadId;
}

class _ThreadMessagesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ThreadMessages,
        List<Message>> with ThreadMessagesRef {
  _ThreadMessagesProviderElement(super.provider);

  @override
  String get threadId => (origin as ThreadMessagesProvider).threadId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
