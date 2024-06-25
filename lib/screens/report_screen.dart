// import 'package:flutter/material.dart';
// import '../services/firestore_service.dart';
// // Import the Report model or use Map<String, dynamic> for simplicity
//
// class ReportTableScreen extends StatelessWidget {
//   final FirestoreService _firestoreService = FirestoreService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Report Table'),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _firestoreService.getReports(), // Implement a Firestore service method to get reports
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           final reports = snapshot.data;
//
//           return Scrollbar(
//             controller: PrimaryScrollController.of(context),
//             thumbVisibility: true, // Ensure scrollbar is always shown
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: DataTable(
//                   columns: [
//                     DataColumn(label: Text('Report ID')),
//                     DataColumn(label: Text('Report Type')),
//                     DataColumn(label: Text('Timestamp')),
//                     DataColumn(label: Text('Address LatLong')),
//                     DataColumn(label: Text('Additional Info')),
//                     DataColumn(label: Text('Image URLs')),
//                     DataColumn(label: Text('Receive Updates')),
//                   ],
//                   rows: reports!.map((report) {
//                     return DataRow(cells: [
//                       DataCell(Text(report['reportID'] ?? '')),
//                       DataCell(Text(report['reportType'] ?? '')),
//                       DataCell(Text(report['timestamp']?.toString() ?? '')),
//                       DataCell(Text(report['addressLatLong'] ?? '')),
//                       DataCell(Text(report['additionalInfo'] ?? '')),
//                       DataCell(
//                         // Example of showing the first image URL
//                         Text(report['imageUrls'] != null && report['imageUrls'].isNotEmpty
//                             ? report['imageUrls'][0]
//                             : ''),
//                       ),
//                       DataCell(Text(report['receiveUpdates']?.toString() ?? '')),
//                     ]);
//                   }).toList(),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
