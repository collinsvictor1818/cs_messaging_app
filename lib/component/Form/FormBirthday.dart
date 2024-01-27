import 'package:cloud_firestore/cloud_firestore.dart';
import '/component/bottom_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FormBirthday extends StatefulWidget {
  final String text;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefix;
  final IconData? suffix;
  final VoidCallback? onClicked;
  final String? label;

  const FormBirthday({
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
  State<FormBirthday> createState() => _FormBirthdayState();
}

class _FormBirthdayState extends State<FormBirthday> {
  late DateTime selectedDate;

  Future<void> showDatePicker(BuildContext context) async {
    final newDateTime = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9),
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate,
                  onDateTimeChanged: (DateTime newDateTime) {
                    final monthDay = DateTime(DateTime.now().year,
                        newDateTime.month, newDateTime.day);
                    setState(() {
                      selectedDate = monthDay;
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                      child: Column(
                        children: [
                          const Icon(Icons.save_alt_outlined),
                          Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontFamily: "Gilmer",
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                onPressed: () async {
                  final formattedDate =
                      selectedDate.toIso8601String().substring(0, 10);
                  widget.controller?.text = formattedDate;

                  // Save the selected date to Firestore
                  await FirebaseFirestore.instance
                      .collection('your_collection_name')
                      .add({
                    'Date': selectedDate,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );

    if (newDateTime != null) {
      final monthDay = DateTime(
        DateTime.now().year,
        newDateTime.month,
        newDateTime.day,
      );
      setState(() {
        selectedDate = monthDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDatePicker(context);
      },
      child: Column(
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
            minLines: 1,
            cursorColor: Theme.of(context).colorScheme.tertiary,
            readOnly: true,
            onTap: () {
              final snackBarHelper = SnackBarHelper(context);
              snackBarHelper.showDateSnack();
            },
            decoration: InputDecoration(
              hintText: "Enter ${widget.text}",
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
                fontFamily: "Gilmer",
                fontWeight: FontWeight.w700,
              ),
              focusColor: Theme.of(context).colorScheme.secondary,
              suffixIcon: Icon(widget.suffix,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7)),
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
            controller: widget.controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${widget.text}';
              }
              return null;
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 7)),
        ],
      ),
    );
  }
}
