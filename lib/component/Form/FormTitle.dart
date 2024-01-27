import 'package:flutter/material.dart';


abstract class formTitle extends StatelessWidget {
  const formTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Theme.of(context).colorScheme.background),
    );
  }
}

Widget FormTitle({
   String? title,
   VoidCallback? onClicked,
}) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.0,
            child: IconButton(
                alignment: Alignment.center,
                // padding: EdgeInsets.only(top: 10),
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, 
                // color: Theme.of(context).colorScheme.tertiary,
                size: 32),
                onPressed: onClicked),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10)
                .add(const EdgeInsets.only(top: 10)),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 30,
                  // color: Theme.of(context).colorScheme.tertiary,
                  fontFamily: "Gilmer",
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    ),
  );
}

