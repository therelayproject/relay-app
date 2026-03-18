import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debounces [action] calls — used for typing indicators (PRES-04) and
/// search-as-you-type (SRCH-01).
class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  final Duration delay;
  Timer? _timer;

  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
