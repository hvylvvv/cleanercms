import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanercms/model/title_model.dart';

class UserDetails {
  List<UserModel> userData = [];

  Future<void> fetchUserData() async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final reportsCollection = FirebaseFirestore.instance.collection('reports');
    final schedulesCollection = FirebaseFirestore.instance.collection('locations');

    final usersSnapshot = await usersCollection.get();
    final reportsSnapshot = await reportsCollection.get();
    final schedulesSnapshot = await schedulesCollection.get();

    userData = [
      UserModel(value: "${usersSnapshot.size}", title: "Users Registered"),
      UserModel(value: "${reportsSnapshot.size}", title: "Reports Filed"),
      UserModel(value: "${schedulesSnapshot.size}", title: "Active Schedules"),
    ];
  }
}

