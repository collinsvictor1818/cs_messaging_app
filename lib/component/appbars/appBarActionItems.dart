import 'package:flutter/material.dart';

class AppBarActionItems extends StatelessWidget {
  const AppBarActionItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            icon: Icon(Icons.settings, size: 27, color: Theme.of(context).colorScheme.tertiary),
            onPressed: () {
                     
                    },),
        const SizedBox(width: 8),
        IconButton(
            icon: Icon(Icons.account_circle_rounded,
                size: 27, color: Theme.of(context).colorScheme.tertiary),
            onPressed: () {
             
              
            }),
        const SizedBox(width: 10),
      ],
    );
  }
}
