// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workspaceListHash() => r'bac336c6af53d96cf0ed01fd69ad6c06bf4933fd';

/// See also [workspaceList].
@ProviderFor(workspaceList)
final workspaceListProvider =
    AutoDisposeFutureProvider<List<Workspace>>.internal(
  workspaceList,
  name: r'workspaceListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$workspaceListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorkspaceListRef = AutoDisposeFutureProviderRef<List<Workspace>>;
String _$createWorkspaceHash() => r'261455c243ee8faae6e8d807247c8335590b3be6';

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

/// See also [createWorkspace].
@ProviderFor(createWorkspace)
const createWorkspaceProvider = CreateWorkspaceFamily();

/// See also [createWorkspace].
class CreateWorkspaceFamily extends Family<AsyncValue<Workspace>> {
  /// See also [createWorkspace].
  const CreateWorkspaceFamily();

  /// See also [createWorkspace].
  CreateWorkspaceProvider call({
    required String workspaceName,
    String? domain,
  }) {
    return CreateWorkspaceProvider(
      workspaceName: workspaceName,
      domain: domain,
    );
  }

  @override
  CreateWorkspaceProvider getProviderOverride(
    covariant CreateWorkspaceProvider provider,
  ) {
    return call(
      workspaceName: provider.workspaceName,
      domain: provider.domain,
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
  String? get name => r'createWorkspaceProvider';
}

/// See also [createWorkspace].
class CreateWorkspaceProvider extends AutoDisposeFutureProvider<Workspace> {
  /// See also [createWorkspace].
  CreateWorkspaceProvider({
    required String workspaceName,
    String? domain,
  }) : this._internal(
          (ref) => createWorkspace(
            ref as CreateWorkspaceRef,
            workspaceName: workspaceName,
            domain: domain,
          ),
          from: createWorkspaceProvider,
          name: r'createWorkspaceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createWorkspaceHash,
          dependencies: CreateWorkspaceFamily._dependencies,
          allTransitiveDependencies:
              CreateWorkspaceFamily._allTransitiveDependencies,
          workspaceName: workspaceName,
          domain: domain,
        );

  CreateWorkspaceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceName,
    required this.domain,
  }) : super.internal();

  final String workspaceName;
  final String? domain;

  @override
  Override overrideWith(
    FutureOr<Workspace> Function(CreateWorkspaceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateWorkspaceProvider._internal(
        (ref) => create(ref as CreateWorkspaceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceName: workspaceName,
        domain: domain,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Workspace> createElement() {
    return _CreateWorkspaceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateWorkspaceProvider &&
        other.workspaceName == workspaceName &&
        other.domain == domain;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceName.hashCode);
    hash = _SystemHash.combine(hash, domain.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CreateWorkspaceRef on AutoDisposeFutureProviderRef<Workspace> {
  /// The parameter `workspaceName` of this provider.
  String get workspaceName;

  /// The parameter `domain` of this provider.
  String? get domain;
}

class _CreateWorkspaceProviderElement
    extends AutoDisposeFutureProviderElement<Workspace>
    with CreateWorkspaceRef {
  _CreateWorkspaceProviderElement(super.provider);

  @override
  String get workspaceName => (origin as CreateWorkspaceProvider).workspaceName;
  @override
  String? get domain => (origin as CreateWorkspaceProvider).domain;
}

String _$updateWorkspaceHash() => r'b7de79d2278f7abb9248ab09518efeb86fee8307';

/// See also [updateWorkspace].
@ProviderFor(updateWorkspace)
const updateWorkspaceProvider = UpdateWorkspaceFamily();

/// See also [updateWorkspace].
class UpdateWorkspaceFamily extends Family<AsyncValue<Workspace>> {
  /// See also [updateWorkspace].
  const UpdateWorkspaceFamily();

  /// See also [updateWorkspace].
  UpdateWorkspaceProvider call({
    required String workspaceId,
    String? workspaceName,
    String? domain,
  }) {
    return UpdateWorkspaceProvider(
      workspaceId: workspaceId,
      workspaceName: workspaceName,
      domain: domain,
    );
  }

  @override
  UpdateWorkspaceProvider getProviderOverride(
    covariant UpdateWorkspaceProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
      workspaceName: provider.workspaceName,
      domain: provider.domain,
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
  String? get name => r'updateWorkspaceProvider';
}

/// See also [updateWorkspace].
class UpdateWorkspaceProvider extends AutoDisposeFutureProvider<Workspace> {
  /// See also [updateWorkspace].
  UpdateWorkspaceProvider({
    required String workspaceId,
    String? workspaceName,
    String? domain,
  }) : this._internal(
          (ref) => updateWorkspace(
            ref as UpdateWorkspaceRef,
            workspaceId: workspaceId,
            workspaceName: workspaceName,
            domain: domain,
          ),
          from: updateWorkspaceProvider,
          name: r'updateWorkspaceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateWorkspaceHash,
          dependencies: UpdateWorkspaceFamily._dependencies,
          allTransitiveDependencies:
              UpdateWorkspaceFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          workspaceName: workspaceName,
          domain: domain,
        );

  UpdateWorkspaceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.workspaceName,
    required this.domain,
  }) : super.internal();

  final String workspaceId;
  final String? workspaceName;
  final String? domain;

  @override
  Override overrideWith(
    FutureOr<Workspace> Function(UpdateWorkspaceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateWorkspaceProvider._internal(
        (ref) => create(ref as UpdateWorkspaceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        workspaceName: workspaceName,
        domain: domain,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Workspace> createElement() {
    return _UpdateWorkspaceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateWorkspaceProvider &&
        other.workspaceId == workspaceId &&
        other.workspaceName == workspaceName &&
        other.domain == domain;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, workspaceName.hashCode);
    hash = _SystemHash.combine(hash, domain.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateWorkspaceRef on AutoDisposeFutureProviderRef<Workspace> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `workspaceName` of this provider.
  String? get workspaceName;

  /// The parameter `domain` of this provider.
  String? get domain;
}

class _UpdateWorkspaceProviderElement
    extends AutoDisposeFutureProviderElement<Workspace>
    with UpdateWorkspaceRef {
  _UpdateWorkspaceProviderElement(super.provider);

  @override
  String get workspaceId => (origin as UpdateWorkspaceProvider).workspaceId;
  @override
  String? get workspaceName =>
      (origin as UpdateWorkspaceProvider).workspaceName;
  @override
  String? get domain => (origin as UpdateWorkspaceProvider).domain;
}

String _$sendInviteHash() => r'aeb315fe1dbfb8f6799564f69ed9586ce3dd2956';

/// See also [sendInvite].
@ProviderFor(sendInvite)
const sendInviteProvider = SendInviteFamily();

/// See also [sendInvite].
class SendInviteFamily extends Family<AsyncValue<void>> {
  /// See also [sendInvite].
  const SendInviteFamily();

  /// See also [sendInvite].
  SendInviteProvider call({
    required String workspaceId,
    required String email,
  }) {
    return SendInviteProvider(
      workspaceId: workspaceId,
      email: email,
    );
  }

  @override
  SendInviteProvider getProviderOverride(
    covariant SendInviteProvider provider,
  ) {
    return call(
      workspaceId: provider.workspaceId,
      email: provider.email,
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
  String? get name => r'sendInviteProvider';
}

/// See also [sendInvite].
class SendInviteProvider extends AutoDisposeFutureProvider<void> {
  /// See also [sendInvite].
  SendInviteProvider({
    required String workspaceId,
    required String email,
  }) : this._internal(
          (ref) => sendInvite(
            ref as SendInviteRef,
            workspaceId: workspaceId,
            email: email,
          ),
          from: sendInviteProvider,
          name: r'sendInviteProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sendInviteHash,
          dependencies: SendInviteFamily._dependencies,
          allTransitiveDependencies:
              SendInviteFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
          email: email,
        );

  SendInviteProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.workspaceId,
    required this.email,
  }) : super.internal();

  final String workspaceId;
  final String email;

  @override
  Override overrideWith(
    FutureOr<void> Function(SendInviteRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SendInviteProvider._internal(
        (ref) => create(ref as SendInviteRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        workspaceId: workspaceId,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SendInviteProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SendInviteProvider &&
        other.workspaceId == workspaceId &&
        other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SendInviteRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;

  /// The parameter `email` of this provider.
  String get email;
}

class _SendInviteProviderElement extends AutoDisposeFutureProviderElement<void>
    with SendInviteRef {
  _SendInviteProviderElement(super.provider);

  @override
  String get workspaceId => (origin as SendInviteProvider).workspaceId;
  @override
  String get email => (origin as SendInviteProvider).email;
}

String _$workspaceInviteLinkHash() =>
    r'9d8a7705232f4159f765ead09b4616fcd923f20e';

/// See also [workspaceInviteLink].
@ProviderFor(workspaceInviteLink)
const workspaceInviteLinkProvider = WorkspaceInviteLinkFamily();

/// See also [workspaceInviteLink].
class WorkspaceInviteLinkFamily extends Family<AsyncValue<String>> {
  /// See also [workspaceInviteLink].
  const WorkspaceInviteLinkFamily();

  /// See also [workspaceInviteLink].
  WorkspaceInviteLinkProvider call(
    String workspaceId,
  ) {
    return WorkspaceInviteLinkProvider(
      workspaceId,
    );
  }

  @override
  WorkspaceInviteLinkProvider getProviderOverride(
    covariant WorkspaceInviteLinkProvider provider,
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
  String? get name => r'workspaceInviteLinkProvider';
}

/// See also [workspaceInviteLink].
class WorkspaceInviteLinkProvider extends AutoDisposeFutureProvider<String> {
  /// See also [workspaceInviteLink].
  WorkspaceInviteLinkProvider(
    String workspaceId,
  ) : this._internal(
          (ref) => workspaceInviteLink(
            ref as WorkspaceInviteLinkRef,
            workspaceId,
          ),
          from: workspaceInviteLinkProvider,
          name: r'workspaceInviteLinkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workspaceInviteLinkHash,
          dependencies: WorkspaceInviteLinkFamily._dependencies,
          allTransitiveDependencies:
              WorkspaceInviteLinkFamily._allTransitiveDependencies,
          workspaceId: workspaceId,
        );

  WorkspaceInviteLinkProvider._internal(
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
    FutureOr<String> Function(WorkspaceInviteLinkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkspaceInviteLinkProvider._internal(
        (ref) => create(ref as WorkspaceInviteLinkRef),
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
  AutoDisposeFutureProviderElement<String> createElement() {
    return _WorkspaceInviteLinkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceInviteLinkProvider &&
        other.workspaceId == workspaceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, workspaceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WorkspaceInviteLinkRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `workspaceId` of this provider.
  String get workspaceId;
}

class _WorkspaceInviteLinkProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with WorkspaceInviteLinkRef {
  _WorkspaceInviteLinkProviderElement(super.provider);

  @override
  String get workspaceId => (origin as WorkspaceInviteLinkProvider).workspaceId;
}

String _$currentWorkspaceHash() => r'020ccdcb17bd8395b5b4cf0fd85c367057d58009';

/// See also [CurrentWorkspace].
@ProviderFor(CurrentWorkspace)
final currentWorkspaceProvider =
    AutoDisposeNotifierProvider<CurrentWorkspace, Workspace?>.internal(
  CurrentWorkspace.new,
  name: r'currentWorkspaceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentWorkspaceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentWorkspace = AutoDisposeNotifier<Workspace?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
