import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'local_prefs.g.dart';

@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) =>
    SharedPreferences.getInstance();

@riverpod
RelayLocalPrefs localPrefs(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider).valueOrNull;
  return RelayLocalPrefs(prefs);
}

/// Typed wrapper around [SharedPreferences] for app settings.
class RelayLocalPrefs {
  RelayLocalPrefs(this._prefs);
  final SharedPreferences? _prefs;

  static const _kThemeMode = 'theme_mode';
  static const _kLastWorkspaceId = 'last_workspace_id';

  ThemeMode get themeMode {
    final value = _prefs?.getString(_kThemeMode);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs?.setString(_kThemeMode, mode.name);
  }

  String? get lastWorkspaceId => _prefs?.getString(_kLastWorkspaceId);

  Future<void> setLastWorkspaceId(String id) async {
    await _prefs?.setString(_kLastWorkspaceId, id);
  }
}
