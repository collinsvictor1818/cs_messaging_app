import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';


class CSVImportPage extends StatelessWidget {
  const CSVImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Import'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _importCSV(context);
              },
              child: const Text('Import CSV'),
            ),
          ],
        ),
      ),
    );
  }
void _importCSV(BuildContext context) async {
  try {
    CollectionReference messages = FirebaseFirestore.instance.collection("messages");

    // Load CSV file
    final String csvString = await rootBundle.loadString("messages.csv");

    // Convert CSV string to list of lists
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

    // Iterate over each row in the CSV data
    for (var row in csvTable) {
      // Extract data from each row
      var record = {
        "userId": row[0],
        "time": row[1],
        "message": row[2]
      };
      
      // Add record to Firestore collection
      messages.add(record);
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV file imported successfully.'),
      ),
    );
  } catch (e) {
    print('Error importing CSV: $e');
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error importing CSV file.'),
      ),
    );
  }
}

}
