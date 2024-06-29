

import 'package:cleanercms/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Posts'),
      ),
      body: StreamBuilder<List<Community>>(
        stream: _firestoreService.getCommunityDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No community documents found'));
          }
          final documents = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('Info')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Resolved')),
              ],
              rows: documents.map((doc) {
                return DataRow(cells: [
                  DataCell(Text(doc.title)),
                  DataCell(Text(doc.info)),
                  DataCell(Text('${doc.location.latitude}, ${doc.location.longitude}')),
                  DataCell(Text(doc.Resolved ? 'Yes' : 'No')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
