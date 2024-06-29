// import 'package:cleanercms/services/firestore_service.dart';
// import 'package:flutter/material.dart';
//
// class SelectReportScreen extends StatelessWidget {
//   final List<Report> reports;
//
//   const SelectReportScreen({Key? key, required this.reports}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select a Report'),
//       ),
//       body: ListView.builder(
//         itemCount: reports.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(reports[index].reportType),
//             subtitle: Text(reports[index].additionalInfo),
//             onTap: () {
//               // Handle selection of report and posting to another Firebase document
//               // _handleReportSelection(context, reports[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   // void _handleReportSelection(BuildContext context, Report report) {
//   //   // Perform operations to post the selected report to another Firebase document
//   //   FirestoreService().postToAnotherDocument(report);
//
//     // Optionally, you can navigate back to the previous screen
//     Navigator.pop(context);
//   }
// }
