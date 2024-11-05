import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../widgets/appbar.dart';
// import '../widgets/navbar.dart';
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

  Future<void> fetchMarkers() async {
    print('hi');
    setState(() {
      isLoading = true;
      print('hi state');
    });

    try{
      final querySnapshot = await FirebaseFirestore.instance.collection('community posts').get();
      print('hi snapshot');
      // List<Marker> fetchedMarkers = [];

      querySnapshot.docs.forEach((document){
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
            // Replace builder with child and GestureDetector
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
        print(fetchedMarkers.toString());
      });
    } catch (e) {
      print('Error fetching markers: $e');
      return ;
    }
    finally {
      setState(() {
        isLoading = false;
        markers = fetchedMarkers;
      });
    }
  }


  @override
  void initState() {
    myPoint = defaultPoint;
    super.initState();
    fetchMarkers();
  }

  LatLng defaultPoint = LatLng(17.9831,-76.7841);

  List listOfPoints = [];
  List<LatLng> points = [];
  // List<Marker> markers = [] ;

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 43, 45, 100),
      // appBar: const CleanerAppBar(title: 'CLEANER+'),
      // endDrawer: Navbar(),

      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialZoom: 10,
              initialCenter: myPoint,
              // onTap: (tapPosition, latLng) => _handleTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(

                markers: markers,
                // markers: fetchMarkers(),

              ),
              PolylineLayer(
                // polylineCulling: false,
                polylines: [
                  Polyline(
                    points: points,
                    color: Colors.black,
                    strokeWidth: 5,
                  ),
                ],
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
          // FloatingActionButton(
          //   heroTag: 'ZoomInFAB',
          //   backgroundColor: Colors.black,
          //   onPressed: () {
          //     mapController.move(mapController.center, mapController.zoom + 1);
          //   },
          //   child: const Icon(
          //     Icons.add,
          //     color: Colors.white,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // FloatingActionButton(
          //   heroTag: 'ZoomOutFAB',
          //   backgroundColor: Colors.black,
          //   onPressed: () {
          //     mapController.move(mapController.center, mapController.zoom - 1);
          //   },
          //   child: const Icon(
          //     Icons.remove,
          //     color: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}


