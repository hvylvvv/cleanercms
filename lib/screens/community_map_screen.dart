import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportMap extends StatefulWidget {
  const ReportMap({super.key});

  @override
  State<ReportMap> createState() => _ReportMapState();
}

class _ReportMapState extends State<ReportMap> {
  late LatLng myPoint;
  bool isLoading = false;
  List<Marker> markers = [];
  List<Marker> fetchedMarkers = [];
  LatLng currentCenter = LatLng(17.9831, -76.7841);
  double currentZoom = 12.5;

  Future<void> fetchMarkers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('community posts').get();
      querySnapshot.docs.forEach((document) {
        GeoPoint geoPoint = document.data()['location'];
        double latitude = geoPoint.latitude;
        double longitude = geoPoint.longitude;

        final position = LatLng(latitude, longitude);
        String title = document.data()['title'] ?? '';
        String description = document.data()['info'] ?? '';
        bool resolved = document.data()['Resolved'] ?? false;

        fetchedMarkers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: position,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(title),
                    content: Text(description),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Icon(
                Icons.flag,
                color: resolved ? Colors.green : Colors.red,
                size: 40.0,
              ),
            ),
          ),
        );
      });
    } catch (e) {
      print('Error fetching markers: $e');
    } finally {
      setState(() {
        isLoading = false;
        markers = fetchedMarkers;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMarkers();
  }

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialZoom: currentZoom,
              initialCenter: currentCenter,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              currentZoom += 1; // Increase zoom level
              mapController.move(currentCenter, currentZoom);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              if (currentZoom > 1) {
                currentZoom -= 1; // Decrease zoom level
                mapController.move(currentCenter, currentZoom);
              }
            },
            child: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
