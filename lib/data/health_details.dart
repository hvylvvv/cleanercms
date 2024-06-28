// import 'package:cleanercms/model/health_model.dart';
//
// class UserDetails {
//   final userData = const [
//     UserModel(
//         icon: 'assets/icons/burn.png', value: "305", title: "Users Registered"),
//     UserModel(
//         icon: 'assets/icons/burn.png', value: "10,983", title: "Reports Filed"),
//     UserModel(
//         icon:'assets/icons/burn.png', value: "7", title: "Active Schedules"),
//   ];
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanercms/model/health_model.dart';

class UserDetails {
  List<UserModel> userData = [];

  Future<void> fetchUserData() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final reportsCollection = FirebaseFirestore.instance.collection('reports');
    final schedulesCollection = FirebaseFirestore.instance.collection('schedules');

    final usersSnapshot = await usersCollection.get();
    final reportsSnapshot = await reportsCollection.get();
    final schedulesSnapshot = await schedulesCollection.get();

    userData = [
      UserModel(icon: 'assets/icons/burn.png', value: "${usersSnapshot.size}", title: "Users Registered"),
      UserModel(icon: 'assets/icons/burn.png', value: "${reportsSnapshot.size}", title: "Reports Filed"),
      UserModel(icon: 'assets/icons/burn.png', value: "${schedulesSnapshot.size}", title: "Active Schedules"),
    ];
  }
}

