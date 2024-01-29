import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Assignment Algorithm',
      home: MessageAssignmentPage(),
    );
  }
}

class MessageAssignmentPage extends StatefulWidget {
  @override
  _MessageAssignmentPageState createState() => _MessageAssignmentPageState();
}

class _MessageAssignmentPageState extends State<MessageAssignmentPage> {
  final MessageAssignmentAlgorithm messageAssignmentAlgorithm =
      MessageAssignmentAlgorithm();

  @override
  void initState() {
    super.initState();
    assignMessages();
  }

  Future<void> assignMessages() async {
    await messageAssignmentAlgorithm.assignMessagesToAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Assignment Algorithm'),
      ),
      body: Center(
        child: Text(
          'Messages have been assigned successfully!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class MessageAssignmentAlgorithm {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Map<String, String> _assignedAgents = {};

  Map<String, String> get assignedAgents => _assignedAgents;

  Future<void> assignMessagesToAgents() async {
    _assignedAgents.clear();

    try {
      QuerySnapshot onlineAgentsSnapshot =
          await _firestore.collection('agent').where('status', isEqualTo: 'online').get();

      List<DocumentSnapshot> onlineAgents = onlineAgentsSnapshot.docs;
      onlineAgents.sort((a, b) =>
          a['assigned_messages_count'].compareTo(b['assigned_messages_count']));

      QuerySnapshot unassignedMessagesSnapshot = await _firestore
          .collection('messages')
          .where('status', isEqualTo: 'unassigned')
          .get();

      List<DocumentSnapshot> unassignedMessages = unassignedMessagesSnapshot.docs;

      for (DocumentSnapshot messageDoc in unassignedMessages) {
        DocumentSnapshot assignedAgent = onlineAgents.first;

        _assignedAgents[messageDoc.id] = assignedAgent.id;

        await _firestore.collection('agent').doc(assignedAgent.id).update({
          'assigned_messages_count': (assignedAgent['assigned_messages_count'] ?? 0) + 1,
        });

        onlineAgents.sort((a, b) =>
            a['assigned_messages_count'].compareTo(b['assigned_messages_count']));
      }

      print('Messages assigned successfully.');
    } catch (e) {
      print('Error assigning messages: $e');
    }
  }
}
