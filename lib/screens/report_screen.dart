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

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  void _fetchReports() {
    _firestoreService.getReports().listen((reports) {
      setState(() {
        _reports = reports;
        _filteredReports = _reports;
      });
    });
  }

  void _filterReports(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredReports = _reports;
      } else {
        _filteredReports = _reports.where((report) =>
        report.reportType.toLowerCase().contains(query.toLowerCase()) ||
            report.additionalInfo.toLowerCase().contains(query.toLowerCase()) ||
            report.addressLatLong.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => NewReportScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      ),
                      child: Text('Generate Post', style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 10, // Adjust column spacing as needed
                headingRowHeight: 30, // Increase the height of heading row
                dataRowHeight: 180, // Increase the height of data rows
                columns: [
                  DataColumn(label: Text('Report Type')),
                  DataColumn(label: Text('Additional Info')),
                  DataColumn(label: Text('GeoLocation')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Image URLs')), // Add column for Image URLs
                ],
                rows: _filteredReports.map((report) {
                  return DataRow(cells: [
                    DataCell(
                      Container(
                        width: 120, // Set fixed width for Report Type column
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          report.reportType,
                          softWrap: true,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 500, // Set fixed width for Additional Info column
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          report.additionalInfo,
                          softWrap: true,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 150, // Set fixed width for Address column
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          report.addressLatLong,
                          softWrap: true,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 120, // Set fixed width for Timestamp column
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          report.timestamp.toString(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 300, // Set fixed width for Image URLs column
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: report.imageUrls.map((url) => InkWell(
                            onTap: () => _launchURL(url),
                            child: Text(
                              url,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              softWrap: true,
                            ),
                          )).toList(),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}