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
  String _resolvedFilter = 'All'; // Internal value for filtering
  final Map<String, String> _resolvedDisplayMap = {
    'All': 'All',
    'Yes': 'Resolved', // Display "Resolved" for 'Yes'
    'No/Not Applicable': 'Unresolved', // Display "Not Resolved" for 'No/Not Applicable'
  };

  bool _isEditMode = false; // Flag to track if the edit mode is enabled

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

  // Function to filter the community posts based on the resolved status
  List<Community> _filterDocuments(List<Community> documents) {
    if (_resolvedFilter == 'All') {
      return documents;
    } else if (_resolvedFilter == 'Yes') {
      return documents.where((doc) => doc.Resolved).toList();
    } else {
      return documents.where((doc) => !doc.Resolved).toList();
    }
  }

  // Function to toggle the resolved status of a post
  Future<void> _toggleResolvedStatus(String postId, bool currentResolvedStatus) async {
    await _firestoreService.updateResolvedStatus(postId, !currentResolvedStatus); // Toggle the resolved status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Posts'),
        actions: [
          // Edit Pencil Icon for changing resolved status
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode; // Toggle the edit mode when the pencil is clicked
              });
            },
          ),
          // Popup menu to select resolved status filter
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _resolvedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _resolvedDisplayMap.keys.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(_resolvedDisplayMap[choice]!),
                );
              }).toList();
            },
          ),
        ],
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
                final documents = snapshot.data!
                    .where((doc) => doc.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                    .toList();

                // Apply the resolved filter
                final filteredDocuments = _filterDocuments(documents);

                if (filteredDocuments.isEmpty) {
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
                    rows: filteredDocuments.map((doc) {
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
                            width: 400,
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
                          // Show the dropdown only when the edit mode is enabled
                          _isEditMode
                              ? DropdownButton<String>(
                            value: doc.Resolved ? 'Resolved' : 'Unresolved',
                            items: [
                              DropdownMenuItem<String>(
                                value: 'Resolved',
                                child: Text('Resolved'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Unresolved',
                                child: Text('Unresolved'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                // Toggle the resolved status when the dropdown selection changes
                                _toggleResolvedStatus(doc.cid, doc.Resolved);
                              }
                            },
                          )
                              : Text(doc.Resolved ? 'Resolved' : 'Unresolved'),
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
