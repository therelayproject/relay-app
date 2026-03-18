import 'package:intl/intl.dart';

/// Locale-aware date/time formatting helpers for message timestamps.
abstract final class DateFormatter {
  /// Returns a short timestamp suitable for message list (e.g. "2:34 PM").
  static String timeOnly(DateTime dt, {String locale = 'en'}) =>
      DateFormat.jm(locale).format(dt.toLocal());

  /// Returns a compact date (e.g. "Mar 17" or "Yesterday" or "2:34 PM").
  static String messageTimestamp(DateTime dt, {String locale = 'en'}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(msgDay).inDays;

    if (diff == 0) return timeOnly(dt, locale: locale);
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat.EEEE(locale).format(dt);
    return DateFormat.yMMMd(locale).format(dt);
  }

  /// Full date/time for tooltips (e.g. "March 17, 2026 at 2:34 PM").
  static String full(DateTime dt, {String locale = 'en'}) =>
      DateFormat.yMMMMd(locale).add_jm().format(dt.toLocal());
}
