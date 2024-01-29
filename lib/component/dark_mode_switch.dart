// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// class DarkModeSwitch extends ConsumerWidget {
//   const DarkModeSwitch({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Icon(Icons.wb_sunny_outlined, 
//         // color: Theme.of(context).colorScheme.tertiary,
//         ),
//         Switch(
//           value: _getDarkMode(ref),
//           onChanged: (_) {
//             ref.read(darkModeProvider.notifier).updateTheme();
//           },
//           inactiveThumbColor:  Theme.of(context).colorScheme.tertiary.withOpacity(.5),
//           trackOutlineColor:  MaterialStateColor.resolveWith((states) =>  Theme.of(context).colorScheme.tertiary.withOpacity(1),),
//           focusColor:  Theme.of(context).colorScheme.tertiary.withOpacity(.5),
//           // activeColor: Theme.of(context).colorScheme.tertiary.withOpacity(.5),
//         ),
//         Icon(_getDarkMode(ref) ? Icons.mode_night: Icons.mode_night_outlined),
//       ],
//     );
//   }

//   bool _getDarkMode(WidgetRef ref) {
//     return ref.watch(darkModeProvider).maybeWhen(
//           data: (darkMode) => darkMode,
//           orElse: () => ThemeMode.system == ThemeMode.dark,
//         );
//   }
// }
