// import 'package:cleanercms/services/firestore_service.dart';
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
        final data = doc.data();
        return Report.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Community>> getCommunityDocuments() {
    return _db.collection('community posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Community.fromJson(data);
      }).toList();
    });
  }

  Stream<List<Pickup>> getPickupDocuments() {
    return _db.collection('pickups').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Pickup.fromJson(doc.data())).toList()
    );
  }


  Future<void> addCommunityDocument(Community document) {
    return _db.collection('community posts').add(document.toJson());
  }

  Future<void> addUser(String uid, Map<String, dynamic> userData) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
      throw e; // Optionally, rethrow for error handling
    }
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
  final String addressNeighbourhood;
  // final String password;
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
    required this.addressNeighbourhood,
    // required this.password,
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
      addressNeighbourhood: json['AddressNeighbourhood'],
      // password: json['Password'],
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

class Community {
  final bool Resolved;
  final String info;
  final GeoPoint location;
  final String title;

  Community({
    required this.Resolved,
    required this.info,
    required this.location,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'resolved': Resolved,
      'info': info,
      'location': location,
      'title': title,
    };
  }

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      Resolved: json['resolved'] ?? false,
      info: json['info'],
      location: json['location'],
      title: json['title'],
    );
  }
}

class Pickup {
  final String additionalInfo;
  final String date;
  final String pickupId;
  final String pickupType;
  final bool receiveUpdates;
  final String time;
  final String userId;
  final String userName;

  Pickup({
    required this.additionalInfo,
    required this.date,
    required this.pickupId,
    required this.pickupType,
    required this.receiveUpdates,
    required this.time,
    required this.userId,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'additionalInfo': additionalInfo,
      'date': date,
      'pickupId': pickupId,
      'pickupType': pickupType,
      'receiveUpdates': receiveUpdates,
      'time': time,
      'userId': userId,
      'userName': userName,
    };
  }

  factory Pickup.fromJson(Map<String, dynamic> json) {
    return Pickup(
      additionalInfo: json['additionalInfo'] ?? '',
      date: json['date'] ?? '',
      pickupId: json['pickupId'] ?? '',
      pickupType: json['pickupType'] ?? '',
      receiveUpdates: json['receiveUpdates'] ?? false,
      time: json['time'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
    );
  }
}
