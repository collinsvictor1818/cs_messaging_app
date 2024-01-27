// Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.tertiary,
//                               borderRadius: BorderRadius.circular(5),
//                             ),

//                             child: ConstrainedBox(
//                               constraints: const BoxConstraints(
//                                 minWidth: 260.0,
//                                 maxWidth: 304.0,
//                               ),
//                               child: Container(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(
//                                     selectedMessage, // Display selected message
//                                     style: TextStyle(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .background,
//                                     ),
//                                   ),
//                                 ),
bool search = true;
var queryResultSet = [];
var tempSearchStore = [];

initiateSearch(value) {
  if (value.length == 0) {
    setState(() {
      queryResultSet = [];
      tempSearchStore = [];
    });
  }
  setState((){
search= true;
  });
  // var capitalizedValues= value.substring(0,1)
  if(queryResultSet.length==0 && value.length==1){

  }
}

void setState(Null Function() param0) {
}

