import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Report>> getReports() {
    return _db.collection('reports').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Report.fromJson(data);
      }).toList();
    });
  }

}

class User {
  final String name;
  final String email;
  final String addressCountry;
  final String addressLatLong;
  final String addressLine1;
  final String addressParish;
  final String addressSuburb;
  final String password;
  final String phone;
  final String uid;

  User({
    required this.name,
    required this.email,
    required this.addressCountry,
    required this.addressLatLong,
    required this.addressLine1,
    required this.addressParish,
    required this.addressSuburb,
    required this.password,
    required this.phone,
    required this.uid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['Name'],
      email: json['Email'],
      addressCountry: json['AddressCountry'],
      addressLatLong: json['AddressLatLong'],
      addressLine1: json['AddressLine1'],
      addressParish: json['AddressParish'],
      addressSuburb: json['AddressSuburb'],
      password: json['Password'],
      phone: json['Phone'],
      uid: json['UserID'],
    );
  }
}


class Report {
  final String reportID;
  final String reportType;
  final String additionalInfo;
  final String addressLatLong;
  final List<String> imageUrls;
  final bool receiveUpdates;
  final DateTime timestamp;

  Report({
    required this.reportID,
    required this.reportType,
    required this.additionalInfo,
    required this.addressLatLong,
    required this.imageUrls,
    required this.receiveUpdates,
    required this.timestamp,
  });

  // Add a factory method to create a Report from a Firestore document
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportID: json['reportID'] ?? '',
      reportType: json['reportType'] ?? '',
      additionalInfo: json['additionalInfo'] ?? '',
      addressLatLong: json['addressLatLong'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      receiveUpdates: json['receiveUpdates'] ?? false,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}
