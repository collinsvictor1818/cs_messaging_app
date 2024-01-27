  import '/styles/style.dart';
import 'package:flutter/material.dart';

import '../../utils/responsive/responsive.dart';


  // ignore: must_be_immutable
  class InfoCard extends StatelessWidget {
    final String? image;
    final String label;
    final String number;
    final Color? cardColor;
    VoidCallback? onClicked;

    InfoCard(
        {super.key,   this.image,required this.label, required this.number,   this.onClicked,   this.cardColor});
  static final MediaQueryData _mediaQueryData = MediaQueryData.fromView(WidgetsBinding.instance.window);
  static double? screenWidth = _mediaQueryData.size.width;
  static double? screenHeight =  _mediaQueryData.size.height;
  static double? blockSizeHorizontal =  (screenWidth! / 100);
  static double? blockSizeVertical =  screenHeight! / 100;
    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onClicked,
        child: Container(
          constraints: BoxConstraints(
              minWidth: Responsive.isDesktop(context)
                  ? 200
                  : screenWidth! / 2 - 40),
          padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 15,
              right: Responsive.isMobile(context) ? 20 : 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(image!, width: 45),
              SizedBox(
                height: blockSizeVertical! * 2,
              ),
              PrimaryText(text: label, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.onBackground, size: 16),
              SizedBox(
                height: blockSizeVertical! * 2,
              ),
              PrimaryText(
                text: number,
                size: 30,
                color:  Theme.of(context).colorScheme.tertiary,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      );
    }
  }
