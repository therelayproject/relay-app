// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'106b441400813a2b4bba3261097e11e5688efb98';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$localPrefsHash() => r'66dcf5d1159905f73d1f91047b950f79fed8882d';

/// See also [localPrefs].
@ProviderFor(localPrefs)
final localPrefsProvider = AutoDisposeProvider<RelayLocalPrefs>.internal(
  localPrefs,
  name: r'localPrefsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localPrefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LocalPrefsRef = AutoDisposeProviderRef<RelayLocalPrefs>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
