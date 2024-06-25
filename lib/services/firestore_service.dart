import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream<List<User>> getUsers() {
  //   return _db.collection('users').snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  // }

  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User.fromJson(data);
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
