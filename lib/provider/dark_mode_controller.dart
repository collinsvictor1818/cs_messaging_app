// import 'dart:ui';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// import 'brightness_controller.dart';

// @riverpod
// class DarkMode extends _$DarkMode {
//   @override
//   FutureOr<bool> build() async {
//     final brightness = await ref.watch(brightnessControllerProvider.future);
//     return brightness == Brightness.dark;
//   }

//   Future<void> updateTheme() async {
//     await ref.watch(brightnessControllerProvider.notifier).updateBrightness();
//   }
// }
