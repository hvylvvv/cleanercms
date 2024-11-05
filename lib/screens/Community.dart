import 'package:cleanercms/screens/new_post_screen.dart';
import 'package:cleanercms/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final _firestoreService = FirestoreService();
  String _searchQuery = '';

  void _createNewPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPostScreen()),
    );
  }

  Future<void> _openOpenStreetMap(double latitude, double longitude) async {
    final urlString = 'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=17/$latitude/$longitude';
    final Uri url = Uri.parse(urlString);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Posts'),
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
                  ElevatedButton(
                    onPressed: _createNewPost,
                    child: Text(
                      '+',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            StreamBuilder<List<Community>>(
              stream: _firestoreService.getCommunityDocuments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No community documents found'));
                }
                final documents = snapshot.data!.where((doc) {
                  return doc.title.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (documents.isEmpty) {
                  return Center(child: Text('No posts found'));
                }

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
                            width: 300,
                            child: Wrap(
                              children: [Text(doc.title)],
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 500,
                            child: Wrap(
                              children: [Text(doc.info)],
                            ),
                          ),
                        ),
                        DataCell(
                          InkWell(
                            onTap: () => _openOpenStreetMap(doc.location.latitude, doc.location.longitude),
                            child: Text(
                              '${doc.location.latitude}, ${doc.location.longitude}',
                              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 90,
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
  }
}
