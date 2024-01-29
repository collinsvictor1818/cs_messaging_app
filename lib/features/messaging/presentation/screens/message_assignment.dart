import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/usecases/message_load_balancer.dart';
import 'all_agents.dart';
import 'chat_screen.dart';

class MessageTasks extends StatefulWidget {
  @override
  _MessageTasksState createState() => _MessageTasksState();
}

class _MessageTasksState extends State<MessageTasks> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MessageAssignmentAlgorithm _messageAssignmentAlgorithm =
      MessageAssignmentAlgorithm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ChatScreen(username: 'User')));
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
                Row(
                  children: [
                    Text(
                      'Tasks',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'Gilmer',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Text(
                  'A list of messages and agents assigned to them',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontFamily: 'Gilmer',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            const Spacer(flex: 1),

            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageTasks()));
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
                )),
            const Spacer(flex: 1),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 35,
                )),
            // IconButton(onPressed: (){}, icon: Icon(Icons.  , color: Theme.of(context).colorScheme.tertiary  , size: 35,))
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return  Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary,));
          }

          var messages = snapshot.data!.docs;

          return Center(
            child: SizedBox(
              width: 500,
              child: DefaultTabController(
                length: 3,
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    var userId = message['userId'];
                    var messageId = message.id; // Document ID
                    var assignedAgentId =
                        _messageAssignmentAlgorithm.assignedAgents[messageId];
              
                    return SizedBox(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text('User ID: $userId'),
                            subtitle: assignedAgentId != null &&
                                    assignedAgentId.isNotEmpty
                                ? FutureBuilder<DocumentSnapshot>(
                                    future: _firestore
                                        .collection('agent')
                                        .doc(assignedAgentId)
                                        .get(),
                                    builder: (context, agentSnapshot) {
                                      if (agentSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Row(
                                          children: [
                                            Text('Assigned Agent: '),
                                            Spacer(),
                                             Text(' Loading...', style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                                          ],
                                        );
                                      }
              
                                      if (!agentSnapshot.hasData) {
                                        return Row(
                                          children: [
                                            const Text(
                                                'Assigned Agent: '),
                                                Spacer(),
                                                  Text(' NOT ASSIGNED', style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                                          ],
                                        );
                                      }
              
                                      var agentData = agentSnapshot.data!.data()
                                          as Map<String, dynamic>;
                                      var agentName = agentData['username'];
              
                                      return Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),child:  Padding(
                                    padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Text('Assigned Agent: '),
                                              Spacer(),
                                               Text('$agentName', style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: BorderRadius.circular(15)),child:  Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text('Assigned Agent: '),
                                      Spacer(),
                                       Text(' NOT ASSIGNED', style: TextStyle(color: Theme.of(context).colorScheme.tertiary),),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(
      MaterialApp(
        home: MessageTasks(),
      ),
    );
