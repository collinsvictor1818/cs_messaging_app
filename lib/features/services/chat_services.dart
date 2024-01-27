//   import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//   String selectedUserID = '';
//   String selectedMessage = '';
//   final TextEditingController _messageController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   List<Map<String, dynamic>> filteredMessages = [];
//   List<Map<String, dynamic>> _messages = [];
//   List<String> agentResponses = []; 
// // void fetchMessages() {
// //     FirebaseFirestore.instance.collection('messages').snapshots().listen((snapshot) {
// //       setState(() {
// //         _messages = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
// //       });
// //     });
// //   }

//   void sendMessageToChatRoom(String response, String senderId, String recipientId) {
//     Timestamp currentTime = Timestamp.now();
//     String documentId = '${widget.username}_$recipientId';
//     CollectionReference chatRoomCollection = FirebaseFirestore.instance.collection('chat_room');

//     Map<String, dynamic> messageDetails = {
//       'recipient_info': {
//         'recipient_id': recipientId,
//         'recipient_name': widget.username,
//       },
//       'sender_id': senderId,
//       'message': selectedMessage,
//       'response': response,
//       'response_time': currentTime,
//     };

//     chatRoomCollection.doc(documentId).set(messageDetails);
//   }

//   void filterMessages(String query) {
//     setState(() {
//       filteredMessages = _messages.where((message) {
//         final String userId = message['userId'].toString().toLowerCase();
//         final String messageText = message['message'].toString().toLowerCase();
//         return userId.contains(query.toLowerCase()) || messageText.contains(query.toLowerCase());
//       }).toList();
//     });
//   }
