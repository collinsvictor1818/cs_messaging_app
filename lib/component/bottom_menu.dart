
import 'package:flutter/material.dart';

import '../styles/pallete.dart';

class SnackBarHelper {
  final BuildContext context;

  SnackBarHelper(this.context);

  void showCustomSnackBarWithMenu() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Theme.of(context).colorScheme.background,
            ),
            child: ListView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                buildCustomMenuItem(
                  "Calendar",
                  () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => TimeTableCalendar()),
                    // );
                  },
                ),
                buildCustomMenuItem(
                  "Schedule",
                  () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const AddAsset(),
                    // ));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDateSnack() {
    DateSnack(context).showDateSnack();
  }

  Widget buildCustomMenuItem(String title, VoidCallback onPressed) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.03),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Gilmer',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColor.green,
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}

class DateSnack {
  final BuildContext context;

  DateSnack(this.context);

  void showDateSnack() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Theme.of(context).colorScheme.background,
            ),
            height: 200, // Set the desired height
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Select Day and Month",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'Gilmer',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          // Date Column
                          SizedBox(
                            width: 180,
                            child: buildColumn(
                              itemCount: 31,
                              itemBuilder: (BuildContext context, int index) =>
                                  Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Month Column
                          Expanded(
                            child: buildColumn(
                              itemCount: 12,
                              itemBuilder: (BuildContext context, int index) =>
                                  Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  getMonthName(index + 1),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildColumn({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      scrollDirection: Axis.vertical, // Allow horizontal scrolling
    );
  }

  String getMonthName(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
