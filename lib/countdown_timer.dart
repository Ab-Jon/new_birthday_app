import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final birthdayDate = DateTime(2025, 5, 5); // 🎂 Your birthday

final countdownProvider = StreamProvider<Duration>((ref) {
  return Stream.periodic(Duration(seconds: 1), (_) {
    final now = DateTime.now();
    return birthdayDate.difference(now);
  });
});
