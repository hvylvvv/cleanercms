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
                  //   onPressed: _createNewPost,
                  //   child: Text('New Post'),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            StreamBuilder<List<Community>>(
              stream: _firestoreService.getPickupDocuments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No pickups found'));
                }
                final documents = snapshot.data!.where((doc) {
                  return doc.title.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10.0,
                    horizontalMargin: 10.0,
                    columns: const [
                      DataColumn(label: Text('Title')),
                      DataColumn(label: Text('Info')),
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Resolved')),
                    ],
                    rows: documents.map((doc) {
                      return DataRow(cells: [
                        DataCell(
                          Container(
                            width: 350, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.title)],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 500, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.info)],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 200, // Set the desired width
                            child: Wrap(
                              children: [
                                Text('${doc.location.latitude}, ${doc.location.longitude}')
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 100, // Set the desired width
                            child: Wrap(
                              children: [Text(doc.Resolved ? 'Yes' : 'No/Not Applicable')],
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
  }}