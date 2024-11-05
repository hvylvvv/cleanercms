


import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  List<Pickup> _pickups = [];
  List<Pickup> _filteredPickups = [];

  @override
  void initState() {
    super.initState();
    _fetchPickups();
  }

  void _fetchPickups() {
    _firestoreService.getPickupDocuments().listen((pickups) {
      setState(() {
        _pickups = pickups;
        _filteredPickups = _pickups;
      });
    });
  }

  void _filterPickups(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPickups = _pickups;
      } else {
        _filteredPickups = _pickups.where((pickup) =>
        pickup.pickupType.toLowerCase().contains(query.toLowerCase()) ||
            pickup.userName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pickup Requests'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchPickups,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by type or user',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterPickups,
            ),
          ),
          Expanded(
            child: _filteredPickups.isEmpty
                ? Center(child: Text('No pickup requests found'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Pickup Type')),
                  DataColumn(label: Text('Date & Time')),
                  DataColumn(label: Text('Receive Updates?')),
                  DataColumn(label: Text('Additional Information')),
                ],
                rows: _filteredPickups.map((pickup) {
                  return DataRow(cells: [
                    DataCell(Text(pickup.userName)),
                    DataCell(Text(pickup.pickupType)),
                    DataCell(Text('${pickup.date}, ${pickup.time}')),
                    DataCell(Text(pickup.receiveUpdates ? 'Yes' : 'No')),
                    DataCell(Text(pickup.additionalInfo)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

