import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String? username;

  const ChatScreen({
    required this.username,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 String selectedUserID = '';
  String selectedMessage = '';
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController(); // Add this line
  List<Map<String, dynamic>> filteredMessages = [];
  List<Map<String, dynamic>> _messages = [];

  void sendMessage(String message, String senderId) {
    FirebaseFirestore.instance.collection('messages').add({
      'userId': senderId,
      'message': message,
      'time': Timestamp.now(),
    });
  }

  void filterMessages(String query) {
    setState(() {
      filteredMessages = _messages.where((message) {
        final String userId = message['userId'].toString().toLowerCase();
        final String messageText = message['message'].toString().toLowerCase();
        return userId.contains(query.toLowerCase()) ||
            messageText.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CS Messaging App',
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontFamily: 'Gilmer',
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: [
                Text(
                  'Welcome: ',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontFamily: 'Gilmer',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${widget.username}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontFamily: 'Gilmer',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            )
          ],
        ),
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.background
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.only(bottom: 38),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        SearchBar(
                          onSearch: filterMessages,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('messages')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary));
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              _messages = snapshot.data!.docs
                                  .map((doc) =>
                                      doc.data() as Map<String, dynamic>)
                                  .toList();
                              return ListView(
                                reverse: true,
                                padding: EdgeInsets.all(16.0),
                                children: filteredMessages.isNotEmpty
                                    ? filteredMessages.map((message) {
                                        return MessageList(
                                          username:
                                              message['userId'].toString(),
                                          message:
                                              message['message'].toString(),
                                          time: message['time'].toString(),
                                          onTap: () {
                                            setState(() {
                                              selectedUserID =
                                                  message['userId'].toString();
                                              selectedMessage =
                                                  message['message'].toString();
                                            });
                                          },
                                        );
                                      }).toList()
                                    : _messages.map((message) {
                                        return MessageList(
                                          username:
                                              message['userId'].toString(),
                                          message:
                                              message['message'].toString(),
                                          time: message['time'].toString(),
                                          onTap: () {
                                            setState(() {
                                              selectedUserID =
                                                  message['userId'].toString();
                                              selectedMessage =
                                                  message['message'].toString();
                                            });
                                          },
                                        );
                                      }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    icon: Icon(
                                      Icons.person,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    'User ID: $selectedUserID',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontFamily: 'Gilmer',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${widget.username}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontFamily: 'Gilmer',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (selectedMessage.isNotEmpty)
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ChatBubble(
                                      selectedMessage: selectedMessage,
                                    )
                                  ],
                                ),
                              ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: _messageController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Message',
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          String message =
                                              _messageController.text;
                                          sendMessage(message, 'agent');
                                          _messageController.clear();
                                        },
                                        icon: Icon(
                                          Icons.send,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
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
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  SearchBar({
    required this.onSearch,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {

  final TextEditingController _searchController = TextEditingController(); // Add this line

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 35,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: TextFormField(
          controller: _searchController,
          maxLines: 1,
          minLines: 1,
          cursorColor: Theme.of(context).colorScheme.tertiary,
          style: TextStyle(
            fontFamily: 'Gilmer',
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.w300,
          ),
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Search",
            hintStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
              fontFamily: "Gilmer",
              fontWeight: FontWeight.w500,
            ),
            focusColor: Theme.of(context).colorScheme.tertiary,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 0,
              ),
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
    return Container(
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
                Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0)
                        .add(EdgeInsets.symmetric(horizontal: 5)),
                    child: Row(
                      children: [
                        Text(
                          'User ID: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Spacer(),
                        Text(
                          time,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Divider(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

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
            borderRadius: BorderRadius.circular(5),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$selectedMessage',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
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

void main() {
  runApp(MaterialApp(
    home: ChatScreen(username: 'John'),
  ));
}
