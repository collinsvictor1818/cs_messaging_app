import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/user_controller.dart';

class AllAgents extends StatefulWidget {
  const AllAgents({Key? key}) : super(key: key);

  @override
  State<AllAgents> createState() => _AllAgentsState();
}

class _AllAgentsState extends State<AllAgents> {
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.fetchUserDataFromFirestore();
  }

  Widget build(BuildContext context) {
      return DefaultTabController(
        length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded,
                    color: Theme.of(context).colorScheme.tertiary),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                'All Agents',
                style: TextStyle(
                  fontFamily: "Gilmer",
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0)
                      .add(EdgeInsets.symmetric(horizontal: 10)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AllAgents()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Refresh',
                              style: TextStyle(
                                fontFamily: 'Gilmer',
                                fontSize: 14,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
          body: Center(
            child: SizedBox(
              width: 420,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TabBar(
                      dividerColor: Theme.of(context).colorScheme.tertiary,
                      indicatorColor: Theme.of(context).colorScheme.tertiary,
                      labelStyle: TextStyle(
                        fontFamily: 'Gilmer',
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'All agents'),
                        Tab(text: 'Online'),
                        Tab(text: 'Booked'),
                      ],
                      labelColor: Theme.of(context).colorScheme.tertiary,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onBackground,
                    ),
                    Expanded(
                      child: buildAllServicesTab(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllServicesTab() {
    return RefreshIndicator(
      onRefresh: () async {
        userController.fetchUserDataFromFirestore();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            FutureBuilder<String>(
              future: userController.getUsername(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final first = snapshot.data;
                  if (first != null) {
                    // Pass the first to the ServiceList
                    return ServiceList(first: first);
                  } else {
                    // Handle the case where first is null (e.g., user not authenticated)
                    return Text('User not authenticated');
                  }
                } else {
                  // Loading indicator while fetching first
                  return  Center(
                      child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchServicesWithStatus(
      String first, String status) async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('agent')
          .where('username', isEqualTo: first)
          .get();

      // String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('agent')
          // .where('status', isEqualTo: status)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

}

class ServiceList extends StatefulWidget {
  final String first;

  ServiceList({required this.first});

  @override
  _ServiceListState createState() => _ServiceListState(first: first);
}

class _ServiceListState extends State<ServiceList> {
  final String first;
  List<QueryDocumentSnapshot> agents = [];

  _ServiceListState({required this.first});

  bool isLoading = true;
  final UserController userController = Get.find();
  @override
  void initState() {
    super.initState();
    loadServices();
  }

  Future<void> loadServices() async {
    try {
      final QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('agent')
          .where('username', isEqualTo: first)
          .get();

      String userDocId = userQuery.docs.first.id;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('agent')
          .doc(userDocId)
          .collection('agent')
          // .orderBy('date',
          //     descending: true) // Order by 'date' in descending order
          .limit(10)
          .get();

      setState(() {
        agents = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    // Load the first 10 agents from the 'agent' subcollection of a specific user
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Display a loading indicator while data is being fetched.
      return Container(
        height: 400,
        child:  Center(
          child:  Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary)),
        ),
      );
    } else if (agents.isEmpty) {
      // Display "No Agent Added" message when the 'agent' collection is empty or doesn't exist.
      return Container(
        height: 200,
        child: const Center(
          child: Text("No Agent Added"),
        ),
      );
    }

    // Build and return the ListView with agent data.
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: agents.length,
      itemBuilder: (context, index) {
        final serviceData = agents[index].data() as Map<String, dynamic>;
        return ViewData(
          agent: serviceData['agent'] ?? '',
          status: serviceData['status'] ?? '',
    
          time: serviceData['end']?.toDate() ?? DateTime.now(),
        );
      },
    );
  }
}

// ViewData Widget remains unchanged as per the original.
// Color getStatusColor(String status, BuildContext context) {
//   if (status == 'Online') {
//     return Theme.of(context).colorScheme.surface;
//   } else if (status == 'Deactivated') {
//     return Theme.of(context).colorScheme.errorContainer;
//   } else if (status == 'Booked') {
//     return Theme.of(context).colorScheme.tertiary;
//   } else if (status.isEmpty) {
//     return Theme.of(context).colorScheme.secondary;
//   }
//   // Default color if status is neither 'Online' nor 'Booked'
//   return Theme.of(context).colorScheme.surface;
// }

// getStatusAction(String status, BuildContext context) {
//   if (status == 'Booked') {
//     Navigator.of(context).push(Mate  rialPageRoute(builder: (context) => const Billing()));
//   } else {
//     // Navigate to another screen or handle differently if the status is not 'Booked'
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const agents()));
//   }
// }

class ViewData extends StatelessWidget {
  final String agent;
 final String status;
  final DateTime time;


  ViewData({
    required this.agent,
required this.status,
    required this.time,

  });

  @override
  Widget build(BuildContext context) {
    // Define a date format
    final dateFormat = DateFormat('MMM d, y'); // Customize the format as needed
    // Color Theme.of(context).colorScheme.tertiary = getStatusColor(status, context);
    // Function() statusAction = getStatusAction(status, context);

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Theme.of(context).colorScheme.secondary,
        child: ExpansionTile(
          shape: Border(),
          title: Text(
            agent,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          subtitle: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.05)),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      ' Status: ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Gilmer',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontFamily: 'Gilmer',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          trailing: SizedBox(
            width: 150,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 15,
                        child: Row(
                          children: [
                            Text(
                              'Last Changed:',
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: 'Gilmer',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 15,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              ' ${dateFormat.format(time)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontFamily: 'Gilmer',
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  InkWell(
                    onTap: () {
                      if (status == 'Booked') {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => Registeragent(),
                        // ));
                      } else {
                        // Navigate to another screen or handle differently if the status is not 'Booked'
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => Registeragent(),
                        // ));
                      }
                    },
                    // onTap: statusAction,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0)
                                .add(EdgeInsets.symmetric(horizontal: 8)),
                            child: Row(
                              children: [
                                Text(
                                  status == 'Booked' ? 'Pay' : 'More',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontFamily: 'Gilmer',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),

                                // Icon(Icons.arrow_right, color: Theme.of(context).colorScheme.background,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   if (status != 'Booked') {
                      //     changeStatus('Booked');
                      //   }
                      // },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0)
                                    .add(EdgeInsets.symmetric(horizontal: 8)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontFamily: 'Gilmer',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      // onTap: () {
                      //   if (status != 'deactivated') {
                      //     changeStatus('deactivated');
                      //   }
                      // },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.05),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0)
                                    .add(EdgeInsets.symmetric(horizontal: 8)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Deactivate',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          fontFamily: 'Gilmer',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
