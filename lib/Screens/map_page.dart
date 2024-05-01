import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:morched/Screens/market_page.dart';

class MapPage extends StatefulWidget {
  final List<Map<String, dynamic>> userData;
  const MapPage({super.key, required this.userData});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    print(widget.userData);
    // Create markers from user data
    _markers = widget.userData.map((userData) {
      final name = userData['name'];
      // Extract position directly
      String positionString = userData['position'];
      // Extract latitude and longitude from the position string
      final latLngRegex = RegExp(r'LatLng\(([-0-9.]+), ([-0-9.]+)\)');
      final match = latLngRegex.firstMatch(positionString);
      if (match != null) {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        final position = LatLng(lat, lng);

        final imageUrl = userData['firstImageUrl'];
        return Marker(
          markerId: MarkerId(name),
          position: position,
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Click here to see details',
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
      } else {
        // Handle invalid position data
        print('Invalid position data: $positionString');
        // Return a default marker
        return Marker(
          markerId: MarkerId(name),
          position: const LatLng(0.0, 0.0), // Default position
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Invalid position',
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(35.21134438573, -0.6278880531234288),
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            markers: Set<Marker>.of(_markers),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.6,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(250, 255, 175, 55),
                      Color.fromARGB(250, 180, 87, 173),
                      Color.fromARGB(250, 255, 87, 199),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: BorderDirectional(
                    top: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      width: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.userData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final imageUrl =
                              widget.userData[index]['firstImageUrl'];
                          final name = widget.userData[index]['name'];

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    String name =
                                        widget.userData[index]['name'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MarketPage(name: name),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SizedBox(
                                      height: 120,
                                      width: 250,
                                      child: imageUrl != null
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset("assets/market.png"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
