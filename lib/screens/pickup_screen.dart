// // import 'package:flutter/material.dart';
// // import '../services/firestore_service.dart';
// //
// // class PickupScreen extends StatefulWidget {
// //   const PickupScreen({super.key});
// //
// //   @override
// //   State<PickupScreen> createState() => _PickupScreenState();
// // }
// //
// // class _PickupScreenState extends State<PickupScreen> {
// //   final TextEditingController _searchController = TextEditingController();
// //   final FirestoreService _firestoreService = FirestoreService();
// //   List<Pickup> _pickups = [];
// //   List<Pickup> _filteredPickups = [];
// //
// //   bool _showDropdown = false;  // New variable to track visibility of the dropdown
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchPickups();
// //   }
// //
// //   void _fetchPickups() {
// //     _firestoreService.getPickupDocuments().listen((pickups) {
// //       setState(() {
// //         _pickups = pickups;
// //         _filteredPickups = _pickups;
// //       });
// //     });
// //   }
// //
// //   void _filterPickups(String query) {
// //     setState(() {
// //       if (query.isEmpty) {
// //         _filteredPickups = _pickups;
// //       } else {
// //         _filteredPickups = _pickups.where((pickup) =>
// //         pickup.pickupType.toLowerCase().contains(query.toLowerCase()) ||
// //             pickup.userName.toLowerCase().contains(query.toLowerCase())
// //         ).toList();
// //       }
// //     });
// //   }
// //
// //   // Function to toggle visibility of the dropdown when the pencil is clicked
// //   void _toggleDropdown() {
// //     setState(() {
// //       _showDropdown = !_showDropdown;  // Toggle the dropdown visibility
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Pickup Requests'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.refresh),
// //             onPressed: _fetchPickups,
// //           ),
// //           // Edit Pencil Icon for showing the dropdown
// //           IconButton(
// //             icon: Icon(Icons.edit),
// //             onPressed: _toggleDropdown,  // Toggle dropdown visibility when clicked
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: _searchController,
// //               decoration: InputDecoration(
// //                 labelText: 'Search',
// //                 hintText: 'Search by type or user',
// //                 prefixIcon: Icon(Icons.search),
// //                 border: OutlineInputBorder(),
// //               ),
// //               onChanged: _filterPickups,
// //             ),
// //           ),
// //           Expanded(
// //             child: _filteredPickups.isEmpty
// //                 ? Center(child: Text('No pickup requests found'))
// //                 : SingleChildScrollView(
// //               scrollDirection: Axis.horizontal,
// //               child:
// //               DataTable(
// //                 dataRowMinHeight: 60, // Minimum row height
// //                 dataRowMaxHeight: 70,
// //
// //                 columns: const [
// //                   DataColumn(label: Text('User')),
// //                   DataColumn(label: Text('Pickup Type')),
// //                   DataColumn(label: Text('Date & Time')),
// //                   DataColumn(label: Text('Receive Updates?')),
// //                   DataColumn(label: Text('Additional Information')),
// //                   DataColumn(label: Text('Status'))
// //                 ],
// //                 rows: _filteredPickups.map((pickup) {
// //                   return
// //                     DataRow(cells: [
// //                       DataCell(Text(pickup.userName)),
// //                       DataCell(Text(pickup.pickupType)),
// //                       DataCell(Text('${pickup.date}, ${pickup.time}')),
// //                       DataCell(Text(pickup.receiveUpdates ? 'Yes' : 'No')),
// //                       // DataCell(Text(pickup.additionalInfo)),
// //                       DataCell(
// //                         Container(
// //                           height: 200, // Set row height
// //                           alignment: Alignment.centerLeft, // Align content if needed
// //                           child: SizedBox(
// //                             width: 200, // Set column width
// //                             child: Text(
// //                               pickup.additionalInfo,
// //                               overflow: TextOverflow.ellipsis,
// //                               maxLines: 3, // Optional: Limit lines
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //
// //                       DataCell(
// //                         _showDropdown
// //                             ? DropdownButton<String>(
// //                           value: pickup.status.isNotEmpty ? pickup.status : 'Unread', // Default to 'Unread' if status is empty
// //                           items: [
// //                             DropdownMenuItem<String>(
// //                               value: 'Unread',
// //                               child: Text('Unread'),
// //                             ),
// //                             DropdownMenuItem<String>(
// //                               value: 'Read',
// //                               child: Text('Read'),
// //                             ),
// //                             DropdownMenuItem<String>(
// //                               value: 'In Progress',
// //                               child: Text('In Progress'),
// //                             ),
// //                             DropdownMenuItem<String>(
// //                               value: 'Completed',
// //                               child: Text('Completed'),
// //                             ),
// //                           ],
// //                           onChanged: (value) {
// //                             if (value != null) {
// //                               _firestoreService.updatePickupStatus(pickup.pickupId, value); // Update status on change
// //                             }
// //                           },
// //                         )
// //                             : Text(pickup.status.isNotEmpty ? pickup.status : 'Unread'), // Display status as text when not editing
// //                       ),
// //                     ]);
// //
// //
// //
// //                 }).toList(),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import '../services/firestore_service.dart';
//
// class PickupScreen extends StatefulWidget {
//   const PickupScreen({super.key});
//
//   @override
//   State<PickupScreen> createState() => _PickupScreenState();
// }
//
// class _PickupScreenState extends State<PickupScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final FirestoreService _firestoreService = FirestoreService();
//   List<Pickup> _pickups = [];
//   List<Pickup> _filteredPickups = [];
//
//   String _resolvedFilter = 'All'; // Track the selected filter
//   final Map<String, String> _resolvedDisplayMap = {
//     'All': 'All',
//     'Unread': 'Unread',
//     'Read': 'Read',
//     'In Progress': 'In Progress',
//     'Completed': 'Completed',
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPickups();
//   }
//
//   void _fetchPickups() {
//     _firestoreService.getPickupDocuments().listen((pickups) {
//       setState(() {
//         _pickups = pickups;
//         _filteredPickups = _pickups;
//       });
//     });
//   }
//
//   void _applyFilter() {
//     setState(() {
//       if (_resolvedFilter == 'All') {
//         _filteredPickups = _pickups;
//       } else {
//         _filteredPickups =
//             _pickups.where((pickup) => pickup.status == _resolvedFilter).toList();
//       }
//     });
//   }
//
//   void _filterPickups(String query) {
//     setState(() {
//       _filteredPickups = _pickups.where((pickup) {
//         final matchesQuery = query.isEmpty ||
//             pickup.pickupType.toLowerCase().contains(query.toLowerCase()) ||
//             pickup.userName.toLowerCase().contains(query.toLowerCase());
//         final matchesStatus = _resolvedFilter == 'All' ||
//             pickup.status == _resolvedFilter;
//         return matchesQuery && matchesStatus;
//       }).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pickup Requests'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               setState(() {
//                 _resolvedFilter = value;
//                 _applyFilter(); // Apply the filter when an option is selected
//               });
//             },
//             itemBuilder: (BuildContext context) {
//               return _resolvedDisplayMap.keys.map((String choice) {
//                 return PopupMenuItem<String>(
//                   value: choice,
//                   child: Text(_resolvedDisplayMap[choice]!),
//                 );
//               }).toList();
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchPickups,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: 'Search',
//                 hintText: 'Search by type or user',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: _filterPickups,
//             ),
//           ),
//           Expanded(
//             child: _filteredPickups.isEmpty
//                 ? const Center(child: Text('No pickup requests found'))
//                 : SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 dataRowMinHeight: 60,
//                 dataRowMaxHeight: 70,
//                 columns: const [
//                   DataColumn(label: Text('User')),
//                   DataColumn(label: Text('Pickup Type')),
//                   DataColumn(label: Text('Date & Time')),
//                   DataColumn(label: Text('Receive Updates?')),
//                   DataColumn(label: Text('Additional Information')),
//                   DataColumn(label: Text('Status')),
//                 ],
//                 rows: _filteredPickups.map((pickup) {
//                   return DataRow(cells: [
//                     DataCell(Text(pickup.userName)),
//                     DataCell(Text(pickup.pickupType)),
//                     DataCell(Text('${pickup.date}, ${pickup.time}')),
//                     DataCell(Text(pickup.receiveUpdates ? 'Yes' : 'No')),
//                     DataCell(
//                       SizedBox(
//                         width: 200,
//                         child: Text(
//                           pickup.additionalInfo,
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 3,
//                         ),
//                       ),
//                     ),
//                     DataCell(Text(pickup.status.isNotEmpty
//                         ? pickup.status
//                         : 'Unread')),
//                   ]);
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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

  String _resolvedFilter = 'All'; // Track the selected filter
  final Map<String, String> _resolvedDisplayMap = {
    'All': 'All',
    'Unread': 'Unread',
    'Read': 'Read',
    'In Progress': 'In Progress',
    'Completed': 'Completed',
  };

  bool _showDropdown = false; // Track the visibility of the dropdown menu for editing statuses

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

  void _applyFilter() {
    setState(() {
      if (_resolvedFilter == 'All') {
        _filteredPickups = _pickups;
      } else {
        _filteredPickups =
            _pickups.where((pickup) => pickup.status == _resolvedFilter).toList();
      }
    });
  }

  void _filterPickups(String query) {
    setState(() {
      _filteredPickups = _pickups.where((pickup) {
        final matchesQuery = query.isEmpty ||
            pickup.pickupType.toLowerCase().contains(query.toLowerCase()) ||
            pickup.userName.toLowerCase().contains(query.toLowerCase());
        final matchesStatus = _resolvedFilter == 'All' ||
            pickup.status == _resolvedFilter;
        return matchesQuery && matchesStatus;
      }).toList();
    });
  }

  void _toggleDropdown() {
    setState(() {
      _showDropdown = !_showDropdown; // Toggle the dropdown visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Requests'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _resolvedFilter = value;
                _applyFilter(); // Apply the filter when an option is selected
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
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleDropdown, // Toggle dropdown visibility for status editing
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
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
              decoration: const InputDecoration(
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
                ? const Center(child: Text('No pickup requests found'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowMinHeight: 60,
                dataRowMaxHeight: 70,
                columns: const [
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Pickup Type')),
                  DataColumn(label: Text('Date & Time')),
                  DataColumn(label: Text('Receive Updates?')),
                  DataColumn(label: Text('Additional Information')),
                  DataColumn(label: Text('Status')),
                ],
                rows: _filteredPickups.map((pickup) {
                  return DataRow(cells: [
                    DataCell(Text(pickup.userName)),
                    DataCell(Text(pickup.pickupType)),
                    DataCell(Text('${pickup.date}, ${pickup.time}')),
                    DataCell(Text(pickup.receiveUpdates ? 'Yes' : 'No')),
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Text(
                          pickup.additionalInfo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                    ),
                    DataCell(
                      _showDropdown
                          ? DropdownButton<String>(
                        value: pickup.status.isNotEmpty
                            ? pickup.status
                            : 'Unread', // Default to 'Unread' if status is empty
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Unread',
                            child: Text('Unread'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Read',
                            child: Text('Read'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'In Progress',
                            child: Text('In Progress'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Completed',
                            child: Text('Completed'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _firestoreService.updatePickupStatus(
                                pickup.pickupId,
                                value); // Update status on change
                          }
                        },
                      )
                          : Text(pickup.status.isNotEmpty
                          ? pickup.status
                          : 'Unread'), // Display status as text when not editing
                    ),
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


