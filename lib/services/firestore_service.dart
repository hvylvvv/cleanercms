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

  Future<void> updateReportStatus(String reportId, bool isRead) async {
    try {
      await _db.collection('reports').doc(reportId).update({
        'read': isRead,  // Set the read status to the value passed
      });
    } catch (e) {
      print('Error updating report status: $e');
    }
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


  // Future<void> addCommunityDocument(Community document) {
  //   return _db.collection('community posts').add(document.toJson());
  // }
  Future<void> addCommunityDocument(Community document) async {
    // Add the document to the Firestore collection and get the reference
    var docRef = await _db.collection('community posts').add(document.toJson());

    // Get the generated ID from Firestore
    String generatedId = docRef.id;

    // Optionally, update the document with the generated ID if you need to store it in the model
    document.cid = generatedId;

    // If you want to update the document after adding it, you can do:
    await docRef.update({'id': generatedId});
  }


  Future<void> addUser(String uid, Map<String, dynamic> userData) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(
        userData);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUser(String userId,
      Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('users').doc(userId).update(updatedData);
      print('User updated successfully');
    } catch (e) {
      print('Error updating user: $e');
      throw e; // Optionally, rethrow for error handling
    }
  }


  Future<void> deleteCommunityPost(String cid) async {
    return await FirebaseFirestore.instance.collection('community posts').doc(cid).delete();
  }

  Future<void> deleteUser(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  // Future<void> updateReportAgency(String reportID, String? agency) async {
  //   await _firestore.collection('reports').doc(reportID).update({
  //     'agency': agency,  // Update the agency field
  //   });
  // }
  Future<void> updateReportAgency(String reportID, String? agency) async {
    try {
      await FirebaseFirestore.instance.collection('reports').doc(reportID).update({
        'agency': agency, // Update the 'agency' field with the new value
      });
    } catch (e) {
      print('Error updating agency: $e');
    }
  }

  Future<void> updateResolvedStatus(String postId, bool newResolvedStatus) async {
    try {
      await FirebaseFirestore.instance.collection('community posts').doc(postId).update({
        'resolved': newResolvedStatus,
      });
    } catch (e) {
      print("Error updating resolved status: $e");
    }
  }

  Future<void> updatePickupStatus(String pickupId, String status) async {
    try {
      await _db.collection('pickups').doc(pickupId).update({
        'status': status, // Update the status field with the new value
      });
    } catch (e) {
      print("Error updating pickup status: $e");
    }
  }

  // Future<void> updateCommunityPost(Community community) async {
  //   try {
  //     await _db.collection('community posts').doc(community.cid).update({
  //       'title': community.title,
  //       'info': community.info,
  //       'resolved': community.Resolved,
  //       // Don't update location unless you want to
  //     });
  //   } catch (e) {
  //     print("Error updating community post: $e");
  //   }
  // }

  Future<void> updateCommunityPost(String postId, String updatedTitle, String updatedInfo) async {
    try {
      await FirebaseFirestore.instance.collection('community posts').doc(postId).update({
        'title': updatedTitle,
        'info': updatedInfo,
        // You can add more fields here as needed
      });
    } catch (e) {
      print('Error updating post: $e');
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
  final bool read;
  String? agency;


  Report({
    required this.reportID,
    required this.reportType,
    required this.additionalInfo,
    required this.addressLatLong,
    required this.imageUrls,
    required this.receiveUpdates,
    required this.timestamp,
    required this.read,
    this.agency,

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
      agency: json['agency'] ?? 'Unassigned',
      read: json['read'] ?? false,
    );
  }
}

class Community {
  final bool Resolved;
  final String info;
  final GeoPoint location;
  final String title;
  String cid;




  Community({
    required this.Resolved,
    required this.info,
    required this.location,
    required this.title,
    required this.cid,



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
      cid: json['cid'],


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
  final String status;

  Pickup({
    required this.additionalInfo,
    required this.date,
    required this.pickupId,
    required this.pickupType,
    required this.receiveUpdates,
    required this.time,
    required this.userId,
    required this.userName,
    required this.status,
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
      'status': status,
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
      status: json['status'] ?? '',
    );
  }
}
