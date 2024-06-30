import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'main_screen.dart';

class MapScreen extends StatefulWidget {
  final String title;
  final String info;
  final bool resolved;

  const MapScreen({
    super.key,
    required this.title,
    required this.info,
    required this.resolved,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void _showAddressDialog(BuildContext context, LatLong latLong, addressData) {
    final TextEditingController addressLatLongController = TextEditingController(text: '${latLong.latitude}, ${latLong.longitude}');
    final TextEditingController addressLine1Controller = TextEditingController(text: addressData['road']);
    final TextEditingController addressSuburbController = TextEditingController(text: addressData['suburb']);
    final TextEditingController addressParishController = TextEditingController(text: addressData['county']);

    void savePost() async {
      try {
        await FirebaseFirestore.instance.collection('community posts').add({
          'title': widget.title,
          'info': widget.info,
          'location': GeoPoint(latLong.latitude, latLong.longitude),
          'resolved': widget.resolved,
          'address': {
            'street': addressLine1Controller.text,
            'town': addressSuburbController.text,
            'parish': addressParishController.text,
          },
        });

        // Navigate back to the MainScreen and show the SnackBar
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (Route<dynamic> route) => false,
        );
        // Show SnackBar on MainScreen after navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          MainScreen.showSubmissionMessage(context);
        });
      } catch (e) {
        print("Error saving post: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save post: $e')),
        );
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm/Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: addressLine1Controller,
                decoration: const InputDecoration(labelText: 'Street Address'),
              ),
              TextFormField(
                controller: addressSuburbController,
                decoration: const InputDecoration(labelText: 'Town'),
              ),
              TextFormField(
                controller: addressParishController,
                decoration: const InputDecoration(labelText: 'Parish'),
              ),
              TextFormField(
                controller: addressLatLongController,
                decoration: const InputDecoration(labelText: 'GeoLocation'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: savePost,
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: FlutterLocationPicker(
        initPosition: const LatLong(17.9906, -76.7896),
        selectLocationButtonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.blue),
        ),
        selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
        selectLocationButtonText: 'Select Location',
        selectLocationButtonLeadingIcon: const Icon(Icons.check),
        initZoom: 15,
        minZoomLevel: 5,
        maxZoomLevel: 20,
        trackMyPosition: true,
        onError: (e) => print("Location Picker Error: $e"),
        onPicked: (pickedData) {
          _showAddressDialog(context, pickedData.latLong, pickedData.addressData);
        },
        onChanged: (pickedData) {
          // Handle any changes if needed
        },
      ),
    );
  }
}
