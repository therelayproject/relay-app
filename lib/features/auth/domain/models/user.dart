import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String displayName,
    String? avatarUrl,
    String? statusText,
    String? statusEmoji,
    @Default(false) bool isBot,
    @Default(UserPresence.offline) UserPresence presence,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

enum UserPresence { online, away, dnd, offline }
