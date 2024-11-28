import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/firestore_service.dart';

class ReportTableScreen extends StatefulWidget {
  @override
  _ReportTableScreenState createState() => _ReportTableScreenState();
}

class _ReportTableScreenState extends State<ReportTableScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  List<Report> _reports = [];
  List<Report> _filteredReports = [];
  String _readStatus = 'Read Status '; // Default option is 'All'
  bool _isEditingAgency = false; // State for enabling agency editing
  String _selectedAgency = 'Agency'; // Default is 'All'


  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  // Fetch reports from Firestore and handle agency values
  void _fetchReports() {
    _firestoreService.getReports().listen((reports) {
      setState(() {
        _reports = reports.map((report) {
          // Check if the agency exists in the report, else assign 'Unassigned'
          if (report.agency == null || report.agency == '') {
            report.agency = 'Unassigned'; // Default value if agency is empty
          }
          return report;
        }).toList();
        _filterReports(_searchController.text);  // Re-filter after fetching
      });
    });
  }


  void _filterReports(String query) {
    setState(() {
      _filteredReports = _reports.where((report) {
        bool matchesQuery = report.reportType.toLowerCase().contains(query.toLowerCase()) ||
            report.additionalInfo.toLowerCase().contains(query.toLowerCase()) ||
            report.addressLatLong.toLowerCase().contains(query.toLowerCase());

        bool matchesReadStatus = _readStatus == 'Read Status ' ||
            (_readStatus == 'Read' && report.read) ||
            (_readStatus == 'Unread' && !report.read);

        bool matchesAgency = _selectedAgency == 'Agency' ||
            (report.agency ?? 'Unassigned') == _selectedAgency;


        return matchesQuery && matchesReadStatus && matchesAgency;
      }).toList();
    });
  }


  // Method to update the agency value of a report
  void _updateAgency(Report report, String? newAgency) async {
    if (newAgency != null) {
      try {
        // Update the agency in Firestore
        await _firestoreService.updateReportAgency(report.reportID, newAgency);

        // Update the agency in the local list
        setState(() {
          report.agency = newAgency; // Update the local agency field directly
        });
      } catch (e) {
        print('Error updating agency: $e');
      }
    }
  }

  // Toggle the read status of a report
  void _toggleReadStatus(Report report) async {
    try {
      bool newStatus = !(report.read); // Default to false if null
      print('Toggling read status for ${report.reportID} to $newStatus');

      await _firestoreService.updateReportStatus(report.reportID, newStatus);
      _fetchReports(); // Refresh the data
    } catch (e) {
      print('Error toggling read status: $e');
    }
  }

  // Launch a URL
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Toggle the editing mode for agency dropdown
  void _toggleEditingMode() {
    setState(() {
      _isEditingAgency = !_isEditingAgency;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min, // To make the row take only as much space as needed
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly space the items
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: _toggleEditingMode, // Toggle editing mode on button press
              ),
              SizedBox(width: 10), // Add spacing between elements if needed
              DropdownButton<String>(
                value: _selectedAgency,
                icon: Icon(Icons.filter_list),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAgency = newValue!;
                    _filterReports(_searchController.text); // Re-filter after selection
                  });
                },
                items: ['Agency', 'NWA', 'NSWMA', 'Unassigned']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 10), // Add spacing between elements if needed
              DropdownButton<String>(
                value: _readStatus,
                icon: Icon(Icons.filter_list),
                onChanged: (String? newValue) {
                  setState(() {
                    _readStatus = newValue!;
                    _filterReports(_searchController.text); // Re-filter after selection
                  });
                },
                items: ['Read Status ', 'Read', 'Unread']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),



      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by type, info, or address',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterReports,
            ),
          ),
          Expanded(
            child: _filteredReports.isEmpty
                ? Center(child: Text('No reports found'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: DataTable(
                  columnSpacing: 10,
                  headingRowHeight: 30,
                  dataRowMaxHeight: 180,
                  columns: [
                    DataColumn(label: Text('Report Type')),
                    DataColumn(label: Text('Additional Info')),
                    DataColumn(label: Text('GeoLocation')),
                    DataColumn(label: Text('Timestamp')),
                    DataColumn(label: Text('Image URLs')),
                    DataColumn(label: Text('Agency')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _filteredReports.map((report) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(report.reportType, softWrap: true),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 350,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(report.additionalInfo, softWrap: true),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: InkWell(
                            onTap: () {
                              // Parse the latitude and longitude from the geolocation string
                              List<String> coords = report.addressLatLong.split(',');
                              if (coords.length == 2) {
                                String latitude = coords[0].trim();
                                String longitude = coords[1].trim();
                                String url = 'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude';

                                // Launch the URL
                                _launchURL(url);
                              } else {
                                print('Invalid geolocation format');
                              }
                            },
                            child: Text(
                              report.addressLatLong,
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ),

                      // DataCell(
                      //   Container(
                      //     width: 150,
                      //     padding: EdgeInsets.symmetric(vertical: 16.0),
                      //     child: Text(report.addressLatLong, softWrap: true),
                      //   ),
                      // ),
                      DataCell(
                        Container(
                          width: 120,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(report.timestamp.toString(), softWrap: true),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 120,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: report.imageUrls.map((url) => InkWell(
                                onTap: () => _launchURL(url),
                                child: Text(
                                  'Attached Image',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              )).toList(),
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 120,
                          child: _isEditingAgency // Show dropdown in editing mode
                              ? DropdownButton<String>(
                            value: report.agency,
                            onChanged: (newValue) async {
                              _updateAgency(report, newValue); // Update the agency
                            },
                            items: ['Unassigned', 'NWA', 'NSWMA'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                              : Text(report.agency ?? 'Unassigned'), // Fallback to 'Unassigned' if null
                    // Display agency as text otherwise
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            report.read ? Icons.mark_email_read : Icons.mark_email_unread,
                            color: report.read ? Colors.green : Colors.grey,
                          ),
                          onPressed: () => _toggleReadStatus(report),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



