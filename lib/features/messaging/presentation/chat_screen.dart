import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../component/chat_bubble.dart';
import '../../../component/message_list.dart';
import '../../../component/search_bar.dart';

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
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                            borderRadius: BorderRadius.circular(30)),
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
                                          // _messageController.clear();
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
                  // Expanded(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.secondary,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: StreamBuilder(
                  //     stream: _firestore.collection('messages').snapshots(),
                  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return Center(child: CircularProgressIndicator());
                  //       }

                  //       if (snapshot.hasError) {
                  //         return Center(child: Text('Error: ${snapshot.error}'));
                  //       }

                  //       if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  //         return ListView.builder(
                  //           itemCount: snapshot.data!.docs.length,
                  //           itemBuilder: (context, index) {
                  //             DocumentSnapshot messageDoc = snapshot.data!.docs[index];
                  //             String message = messageDoc['message'];

                  //             // Check if the field "assigned_agent" exists in the document
                  //             String assignedAgent = messageDoc['assigned_agent'] != null
                  //                 ? messageDoc['assigned_agent']
                  //                 : 'Unassigned';

                  //             return ListTile(
                  //               title: Text(message),
                  //               subtitle: Text('Assigned to: $assignedAgent'),
                  //             );
                  //           },
                  //         );
                  //       }

                  //       return Center(child: Text('No messages available'));
                  //     },
                  //   ),

                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
