import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String? selectedMessage;

  const ChatBubble({
    Key? key,
    required this.selectedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(5.0).add(EdgeInsets.symmetric(horizontal: 55)),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 50.0,
              maxWidth: 500.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    '$selectedMessage',
                    
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResponseCard extends StatelessWidget {
  final String? message;
  final String? response;
  const ResponseCard({
    Key? key,
    required this.message,
    this.response
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(5.0).add(EdgeInsets.symmetric(horizontal: 55)),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 50.0,
              maxWidth: 500.0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '$message' ?? '$response',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
