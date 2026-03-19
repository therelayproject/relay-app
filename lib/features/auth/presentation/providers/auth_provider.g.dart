// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateHash() => r'e574581fbb47759c7ba633fc56847ee7a14702b3';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider =
    AutoDisposeAsyncNotifierProvider<AuthState, AuthSession>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = AutoDisposeAsyncNotifier<AuthSession>;
String _$passwordResetRequestHash() =>
    r'783c11e6afa3cc78fd72b4d38a9d74dd9dd65755';

/// Manages password-reset request flow (stateless — just AsyncValue<void>).
///
/// Copied from [PasswordResetRequest].
@ProviderFor(PasswordResetRequest)
final passwordResetRequestProvider = AutoDisposeNotifierProvider<
    PasswordResetRequest, AsyncValue<void>>.internal(
  PasswordResetRequest.new,
  name: r'passwordResetRequestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$passwordResetRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PasswordResetRequest = AutoDisposeNotifier<AsyncValue<void>>;
String _$passwordResetConfirmHash() =>
    r'd2adb37d907d5af3a0c2965184b9e61833bc94d9';

/// Manages the "confirm new password" step.
///
/// Copied from [PasswordResetConfirm].
@ProviderFor(PasswordResetConfirm)
final passwordResetConfirmProvider = AutoDisposeNotifierProvider<
    PasswordResetConfirm, AsyncValue<void>>.internal(
  PasswordResetConfirm.new,
  name: r'passwordResetConfirmProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$passwordResetConfirmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PasswordResetConfirm = AutoDisposeNotifier<AsyncValue<void>>;
String _$profileUpdateHash() => r'233b0f949b2502dac8ec8f0e28918d7cb48d5cfd';

/// Manages profile update.
///
/// Copied from [ProfileUpdate].
@ProviderFor(ProfileUpdate)
final profileUpdateProvider =
    AutoDisposeNotifierProvider<ProfileUpdate, AsyncValue<void>>.internal(
  ProfileUpdate.new,
  name: r'profileUpdateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileUpdateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileUpdate = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
