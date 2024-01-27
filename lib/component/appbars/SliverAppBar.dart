import 'package:flutter/material.dart';


class customAppBar extends StatelessWidget {
  const customAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Common Items',
      theme: ThemeData(primaryColor: Theme.of(context).colorScheme.background),
    );
  }
}

Widget CustomAppBar({
  required String title,
  required VoidCallback onClickedBack,
  required VoidCallback onClickedHome,
}) {
  return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
          // color:Theme.of(context).colorScheme.tertiary
          ),
          onPressed: onClickedHome),
      actions: [
        IconButton(
            icon: Image.asset("H_Colored.png"),
            iconSize: 35,
            onPressed: onClickedBack),
        const Padding(padding: EdgeInsets.all(3)),
      ],
      elevation: 0.0,
      toolbarHeight: 72,
      title: Text(title,
          style: const TextStyle(
              // color: Theme.of(context).colorScheme.tertiary,
              fontFamily: 'Gilmer',
              fontSize: 23,
              fontWeight: FontWeight.w700)),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
 ),
        padding: const EdgeInsets.only(bottom: 38),
      ));
}
