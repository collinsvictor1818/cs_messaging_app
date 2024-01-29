import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../component/chat_bubble.dart';
import '../../../../component/message_list.dart';
import '../../../../component/search_bar.dart';
import 'all_agents.dart';
import 'message_assignment.dart';

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
  String previousResponse = '';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredMessages = [];
  List<Map<String, dynamic>> _messages = [];
  List<String> agentResponses = []; // List to hold agent responses

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  void fetchMessages() {
    FirebaseFirestore.instance
        .collection('messages')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    });
  }

  void sendMessageToChatRoom(
      String response, String senderId, String recipientId) {
    Timestamp currentTime = Timestamp.now();
    String documentId = '${widget.username}_$recipientId';
    CollectionReference chatRoomCollection =
        FirebaseFirestore.instance.collection('chat_room');

    Map<String, dynamic> messageDetails = {
      'recipient_info': {
        'recipient_id': recipientId,
        'recipient_name': widget.username,
      },
      'sender_id': senderId,
      'message': selectedMessage,
      'response': response,
      'response_time': currentTime,
    };

    // Check if the sender is the agent
    if (senderId == 'agent') {
      // Clear the agentResponses list when sending a new message
      setState(() {
        agentResponses.add(response);
      });
    }

    // Update Firestore with message details
    chatRoomCollection.doc(documentId).set(messageDetails);
  }

  Future<void> updateMessages(
      String response, String senderId, String recipientId) async {
    Timestamp currentTime = Timestamp.now();
    try {
      final QuerySnapshot messageQuery = await FirebaseFirestore.instance
          .collection('messages')
          .where('userId', isEqualTo: senderId)
          .get();

      if (messageQuery.docs.isNotEmpty) {
        String userDocId = messageQuery.docs.first.id;
        CollectionReference messageCollection =
            FirebaseFirestore.instance.collection('messages');

        Map<String, dynamic> copyOfMessageDetails = {
          'recipient_info': {
            'recipient_name': widget.username,
          },
          'response': response,
          'response_time': currentTime,
        };

        await messageCollection.doc(userDocId).update(copyOfMessageDetails);
      } else {
        print('No documents found for the given query.');
      }
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions here
      print('Firebase Exception: $e');
    } catch (e, stackTrace) {
      // Handle other exceptions
      print('Error: $e');
      print('Stack Trace: $stackTrace');
    }
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
        title: Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(username: 'User')));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset('assets/cs_messaging_app_logo_mark.png',
                      width: 75, height: 75),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Row(
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
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                    ),
                  )
                ],
              ),
              const Spacer(flex: 1),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MessageTasks()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0)
                          .add(const EdgeInsets.symmetric(horizontal: 15)),
                      child: Text(
                        'Tasks',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontFamily: 'Gilmer',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                focusColor: Theme.of(context).colorScheme.tertiary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0)
                          .add(const EdgeInsets.symmetric(horizontal: 15)),
                      child: Text(
                        'Priority',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontFamily: 'Gilmer',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AllAgents()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0)
                          .add(const EdgeInsets.symmetric(horizontal: 15)),
                      child: Text(
                        'Agents',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontFamily: 'Gilmer',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 35,
                  )),
            ],
          ),
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
                        CustomSearchBar(
                          onSearch: filterMessages,
                          searchController: _searchController,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Show CircularProgressIndicator if messages are still loading
                                      if (_messages.isEmpty)
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary),
                                            ),
                                          ),
                                        ),
                                      // Show messages once they are loaded
                                      if (_messages.isNotEmpty)
                                        filteredMessages.isNotEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: filteredMessages
                                                    .map((message) {
                                                  return MessageList(
                                                    username: message['userId']
                                                        .toString(),
                                                    message: message['message']
                                                        .toString(),
                                                    time: message['time']
                                                        .toString(),
                                                    onTap: () {
                                                      setState(() {
                                                        selectedUserID =
                                                            message['userId']
                                                                .toString();
                                                        selectedMessage =
                                                            message['message']
                                                                .toString();
                                                        previousResponse =
                                                            message['response']
                                                                .toString();
                                                      });
                                                    },
                                                  );
                                                }).toList(),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children:
                                                    _messages.map((message) {
                                                  return MessageList(
                                                    username: message['userId']
                                                        .toString(),
                                                    message: message['message']
                                                        .toString(),
                                                    time: message['time']
                                                        .toString(),
                                                    onTap: () {
                                                      setState(() {
                                                        selectedUserID =
                                                            message['userId']
                                                                .toString();
                                                        selectedMessage =
                                                            message['message']
                                                                .toString();
                                                        previousResponse =
                                                            message['response']
                                                                .toString();
                                                        agentResponses.clear();
                                                      });
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                            borderRadius: BorderRadius.circular(20)),
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
                                    icon: const Icon(
                                      Icons.person,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    'User ID:',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontFamily: 'Gilmer',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    ' $selectedUserID',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontFamily: 'Gilmer',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            if (selectedMessage.isNotEmpty)
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ChatBubble(
                                        selectedMessage: selectedMessage,
                                      ),
                                      for (var response in agentResponses)
                                        ResponseCard(
                                          message: response,
                                        ),
                                      //  if (previousResponse.isNotEmpty)
                                      // ResponseCard(
                                      //   message: previousResponse,
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Center(
                                child: Expanded(
                                  child: Center(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 120.0),
                                              child: Opacity(
                                                opacity: 0.1,
                                                child: Image.asset(
                                                  'assets/cs_messaging_app_logo_mark.png',
                                                  width: 200,
                                                  height: 175,
                                                
                                                ),
                                              ),

                                          ),
                                          Center(
                                            child: Container(
                                              child: Text(
                                                  'CS Messaging \n  App Online',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground.withOpacity(0.1)  ,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      wordSpacing: 0.1,
                                                      letterSpacing: 0.2,
                                                      fontFamily: "Gilmer",
                                                      fontSize: 36), textAlign: TextAlign.center,),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(15),
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
                                          String response =
                                              _messageController.text;
                                          updateMessages(response,
                                              selectedUserID, 'agent');
                                          sendMessageToChatRoom(
                                              message, 'agent', selectedUserID);
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
