import 'package:cloud_firestore/cloud_firestore.dart';

class MessageAssignmentAlgorithm {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> assignMessagesToAgents() async {
    try {
      // Query online agents
      QuerySnapshot onlineAgentsSnapshot =
          await _firestore.collection('agent').where('online', isEqualTo: 'online').get();

      List<DocumentSnapshot> onlineAgents = onlineAgentsSnapshot.docs;

      // Sort agents by the number of messages they have assigned
      onlineAgents.sort((a, b) => a['assigned_messages_count'].compareTo(b['assigned_messages_count']));

      // Query messages that are not assigned to any agent and are not in progress
      QuerySnapshot unassignedMessagesSnapshot =
          await _firestore.collection('messages').where('assigned_agent', isEqualTo: null).where('status', isEqualTo: 'unassigned').get();

      List<DocumentSnapshot> unassignedMessages = unassignedMessagesSnapshot.docs;

      // Assign messages to agents
      for (DocumentSnapshot messageDoc in unassignedMessages) {
        // Find the agent with the fewest assigned messages
        DocumentSnapshot assignedAgent = onlineAgents.first;

        // Mark the message as in progress and assign it to the agent
        await _firestore.runTransaction((transaction) async {
          DocumentSnapshot freshMessageDoc =
              await transaction.get(messageDoc.reference);
          if (!freshMessageDoc.exists) {
            throw Exception('Message does not exist!');
          }

          // Check if the message is still unassigned and not in progress
          if (freshMessageDoc['status'] == 'unassigned') {
            // Update message status and assigned agent
            transaction.update(messageDoc.reference, {
              'status': 'in-progress',
              'assigned_agent': assignedAgent.id,
            });

            // Update the assigned message count for the agent
            transaction.update(_firestore.collection('agent').doc(assignedAgent.id), {
              'assigned_messages_count': (assignedAgent['assigned_messages_count'] ?? 0) + 1,
            });
          } else {
            throw Exception('Message is already assigned or in progress.');
          }
        });

        // Re-sort the agents
        onlineAgents.sort((a, b) => a['assigned_messages_count'].compareTo(b['assigned_messages_count']));
      }

      print('Messages assigned successfully.');
    } catch (e) {
      print('Error assigning messages: $e');
    }
  }
}