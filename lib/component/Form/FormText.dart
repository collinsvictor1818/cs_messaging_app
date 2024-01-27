import 'package:flutter/material.dart';

class FormText extends StatefulWidget {
  final String text;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefix;
  final IconData? suffix;
  final VoidCallback? onClicked;
  final String? label;

  const FormText({
    Key? key,
     required this.text,
   this.hint,
    this.controller,
    this.prefix,
    this.suffix,
    this.onClicked,
    this.label,
  }) : super(key: key);

  @override
  State<FormText> createState() => _FormTextState();
}

class _FormTextState extends State<FormText> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.text,
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: "Gilmer",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        TextFormField(
          
          maxLines: 3,
          controller: widget.controller,
          cursorColor: Theme.of(context).colorScheme.tertiary,
          minLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter ${widget.text}';
            }
            return null;
          },
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: "Enter ${widget.text}",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontFamily: "Gilmer",
              fontWeight: FontWeight.w700,
            ),
            focusColor: Theme.of(context).colorScheme.secondary,
            suffixIcon: Icon(widget.suffix, color:Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
          
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
      ],
    );
  }
}
