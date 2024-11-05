import 'package:cleanercms/screens/new_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _scheduleData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _fetchScheduleData();
  }

  Future<void> _fetchScheduleData() async {
    try {
      final snapshot = await _firestore.collection('locations').get();
      final data = snapshot.docs.map((doc) {
        return {
          'streetName': doc.id,
          'zone': doc.data()['zone'],
          'days': doc.data()['days'],
        };
      }).toList();

      setState(() {
        _scheduleData = data;
        _filteredData = data;
        _isLoading = false; // Update loading state
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Update loading state in case of error
      });
      // Optionally handle the error (e.g., show a message)
    }
  }

  void _filterSchedule(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _scheduleData;
      } else {
        _filteredData = _scheduleData.where((location) {
          final streetName = location['streetName']?.toLowerCase() ?? '';
          final zone = (location['zone']).toString().toLowerCase();
          final days = (location['days'] as List).join(', ').toLowerCase();
          return streetName.contains(query.toLowerCase()) ||
              zone.contains(query.toLowerCase()) ||
              days.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _addNewSchedule() {
    // Navigate to a new screen for adding a new schedule
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewScheduleScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Schedules'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchScheduleData,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Aligns children to the start of the cross axis
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search by street name, zone, or days',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _filterSchedule,
                  ),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addNewSchedule,
                  child: const Text(
                    '+',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          // Text('hi'),
          Expanded(
            child: _isLoading // Show loading indicator while fetching data
                ? const Center(child: CircularProgressIndicator())
                : _filteredData.isEmpty
                ? const Center(child: Text('No schedule data available.'))
                : Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(label: Text('Street Name')),
                      DataColumn(label: Text('Zone')),
                      DataColumn(label: Text('Pickup Days')),
                    ],
                    rows: _filteredData.map((location) {
                      final streetName = location['streetName'] ?? 'N/A';
                      final zone = location['zone'];
                      final days = location['days'];

                      return DataRow(
                        cells: [
                          DataCell(Text(streetName)),
                          DataCell(Text(
                            zone is List ? zone.join(', ') : (zone
                                ?.toString() ?? 'N/A'),
                          )),
                          DataCell(Text(
                            days is List ? days.join(', ') : (days
                                ?.toString() ?? 'N/A'),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

