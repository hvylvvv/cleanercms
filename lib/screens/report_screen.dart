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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Convert the string to a Uri
    if (await canLaunchUrl(uri.toString() as Uri)) {
      await launchUrl(uri.toString() as Uri);
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
                padding: const EdgeInsets.only(left: 30.0), // Add left padding
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
                  ],
                  rows: _filteredReports.map((report) {
                    return DataRow(cells: [
                      DataCell(
                        Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            report.reportType,
                            softWrap: true,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 500,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            report.additionalInfo,
                            softWrap: true,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 150,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            report.addressLatLong,
                            softWrap: true,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 120,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            report.timestamp.toString(),
                            softWrap: true,
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          width: 120,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: report.imageUrls.map((url) => InkWell(
                              onTap: () => _launchURL(url),
                              child: Text(
                                'Attached Image',
                                style: TextStyle(
                                  color: Colors.blue,
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
            ),
          ),

        ],
      ),
    );
  }
}
