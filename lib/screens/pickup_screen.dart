// import 'package:cleanercms/screens/new_pickup_screen.dart';
import 'package:cleanercms/services/firestore_service.dart';
import 'package:flutter/material.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final _firestoreService = FirestoreService();
  String _searchQuery = '';

  // void _createNewPickup() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => NewPickupScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup Requests'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  // ElevatedButton(
                  //   onPressed: (){},
                  //   child: Text('New Pickup'),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            StreamBuilder<List<Pickup>>(
              stream: _firestoreService.getPickupDocuments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No pickup requests found'));
                }
                final documents = snapshot.data!.where((doc) {
                  return doc.pickupType.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10.0,
                    horizontalMargin: 10.0,
                    columns: const [
                      DataColumn(label: Text('User')),
                      DataColumn(label: Text('Pickup Type')),
                      DataColumn(label: Text('Date & Time')),
                      // DataColumn(label: Text('Time')),
                      DataColumn(label: Text('Receive Updates')),
                      DataColumn(label: Text('Additional Info')),

                    ],
                    rows: documents.map((doc) {
                      return DataRow(cells: [
                        DataCell(
                          Container(
                            width: 150, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.userName)],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 200, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.pickupType)],
                            ),
                          ),
                        ),

                        DataCell(
                          Container(
                            width: 150, // Set the desired width
                            child: Wrap(
                              children: [Text('${doc.date}, ${doc.time}')],
                            ),
                          ),
                        ),
                        // DataCell(
                        //   Container(
                        //     width: 100, // Set the desired width
                        //     child: Wrap(
                        //       children: [Text(doc.time)],
                        //     ),
                        //   ),
                        // ),
                        DataCell(
                          Container(
                            width: 200, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.receiveUpdates ? 'Yes' : 'No')],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 300, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.additionalInfo)],
                            ),
                          ),
                        ),

                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
