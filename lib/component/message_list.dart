import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  final VoidCallback onTap;

  const MessageList({
    Key? key,
    required this.username,
    required this.message,
    required this.time,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0)
              .add(EdgeInsets.symmetric(horizontal: 5)),
          child: InkWell(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor:
                Theme.of(context).colorScheme.tertiary.withOpacity(0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                          color: Theme.of(context).colorScheme.onBackground),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0)
                            .add(EdgeInsets.symmetric(horizontal: 5)),
                        child: Row(
                          children: [
                            Text('User ID: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                overflow: TextOverflow.ellipsis),
                            Text(username,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                overflow: TextOverflow.ellipsis),
                            Spacer(flex: 1),
                            Text(
                              time,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).hintColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
