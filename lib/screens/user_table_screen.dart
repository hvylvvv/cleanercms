import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import '../services/firestore_service.dart' as fs;
import 'package:url_launcher/url_launcher.dart';

class UserTableScreen extends StatefulWidget {
  @override
  _UserTableScreenState createState() => _UserTableScreenState();
}

class _UserTableScreenState extends State<UserTableScreen> {
  final TextEditingController _searchController = TextEditingController();
  final fs.FirestoreService _firestoreService = fs.FirestoreService();
  List<fs.User> _users = [];
  List<fs.User> _filteredUsers = [];


  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    _firestoreService.getUsers().listen((users) {
      setState(() {
        _users = users;
        _filteredUsers = _users;
      });
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = _users.where((user) =>
        user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.addressLine1.toLowerCase().contains(query.toLowerCase()) ||
            user.phone.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  Future<void> _openOpenStreetMap(double latitude, double longitude) async {
    final urlString = 'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=17/$latitude/$longitude';
    final Uri url = Uri.parse(urlString); //

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showCreateUserDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressCountryController = TextEditingController();
    final TextEditingController addressLine1Controller = TextEditingController();
    final TextEditingController addressNeighbourhoodController = TextEditingController();
    final TextEditingController addressSuburbController = TextEditingController();
    final TextEditingController addressLatLongController = TextEditingController();
    final TextEditingController addressParishController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              TextField(controller: addressCountryController, decoration: InputDecoration(labelText: 'Country')),
              TextField(controller: addressLine1Controller, decoration: InputDecoration(labelText: 'Address Line 1')),
              TextField(controller: addressNeighbourhoodController, decoration: InputDecoration(labelText: 'Address Line 2')),
              TextField(controller: addressSuburbController, decoration: InputDecoration(labelText: 'Address Line 3')),
              TextField(controller: addressLatLongController, decoration: InputDecoration(labelText: 'Geolocation')),
              TextField(controller: addressParishController, decoration: InputDecoration(labelText: 'Parish')),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _createUser(
                emailController.text,
                passwordController.text,
                nameController.text,
                addressCountryController.text,
                addressLine1Controller.text,
                addressNeighbourhoodController.text,
                addressSuburbController.text,
                addressParishController.text,
                addressLatLongController.text,
                phoneController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createUser(String email, String password, String name, String country, String line1, String neighbourhood, String parish, String phone, String suburb, String latlong) async {
    try {
      auth.UserCredential userCredential = await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;

      await _firestoreService.addUser(userCredential.user!.uid, {
        'UserID': userId,
        'Name': name,
        'Email': email,
        'AddressCountry': country,
        'AddressLine1': line1,
        'AddressNeighbourhood': neighbourhood,
        'AddressSuburb': suburb,
        'AddressLatLong': latlong,
        'AddressParish': parish,
        'Phone': phone,
      });
      _fetchUsers();
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  void _showEditUserDialog(BuildContext context, fs.User user) {
    final TextEditingController nameController = TextEditingController(text: user.name);
    final TextEditingController emailController = TextEditingController(text: user.email);
    final TextEditingController addressCountryController = TextEditingController(text: user.addressCountry);
    final TextEditingController addressLine1Controller = TextEditingController(text: user.addressLine1);
    final TextEditingController addressNeighbourhoodController = TextEditingController(text: user.addressNeighbourhood);
    final TextEditingController addressSuburbController = TextEditingController(text: user.addressSuburb);
    final TextEditingController addressLatLongController = TextEditingController(text: user.addressLatLong);
    final TextEditingController addressParishController = TextEditingController(text: user.addressParish);
    final TextEditingController phoneController = TextEditingController(text: user.phone);
    // String userId = userCredential.user!.uid;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: addressCountryController, decoration: InputDecoration(labelText: 'Country')),
              TextField(controller: addressLine1Controller, decoration: InputDecoration(labelText: 'Address Line 1')),
              TextField(controller: addressNeighbourhoodController, decoration: InputDecoration(labelText: 'Neighborhood')),
              TextField(controller: addressSuburbController, decoration: InputDecoration(labelText: 'Suburb')),
              TextField(controller: addressLatLongController, decoration: InputDecoration(labelText: 'Geolocation')),
              TextField(controller: addressParishController, decoration: InputDecoration(labelText: 'Parish')),
              TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Phone')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _updateUser(
                user.uid,
                nameController.text,
                emailController.text,
                addressCountryController.text,
                addressLine1Controller.text,
                addressNeighbourhoodController.text,
                addressSuburbController.text,
                addressLatLongController.text,
                addressParishController.text,
                phoneController.text,
              );
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUser(
      String userId, String name, String email, String country, String line1,
      String neighbourhood, String suburb, String latlong, String parish, String phone) async {
    try {
      await _firestoreService.updateUser(userId, {
        'Name': name,
        'Email': email,
        'AddressCountry': country,
        'AddressLine1': line1,
        'AddressNeighbourhood': neighbourhood,
        'AddressSuburb': suburb,
        'AddressLatLong': latlong,
        'AddressParish': parish,
        'Phone': phone,
      });
      _fetchUsers();
    } catch (e) {
      print('Error updating user: $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchUsers,
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed:
                () => _showCreateUserDialog(context),
          )

        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by name, email, address, or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: Text('No users found'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Geolocation')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('')),
                ],
                rows: _filteredUsers.map((user) {
                  final latLongString = user.addressLatLong; // This should be the string format "latitude,longitude"
                  final latLongList = latLongString.split(',');

                  final latitude = double.tryParse(latLongList[0].trim()) ?? 0.0;
                  final longitude = double.tryParse(latLongList[1].trim()) ?? 0.0;

                  return DataRow(cells: [
                    DataCell(Text(user.name)),
                    DataCell(Text(user.email)),
                    DataCell(Text('${user.addressLine1}, ${user.addressParish}, ${user.addressSuburb}')),
                    DataCell(
                      InkWell(
                        onTap: () => _openOpenStreetMap(latitude, longitude),
                        child: Text(
                          '${user.addressLatLong}',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(user.phone)),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showEditUserDialog(context, user),
                      ),
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