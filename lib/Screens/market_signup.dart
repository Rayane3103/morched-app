// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morched/Components/customfield.dart';
import 'package:morched/Components/drop_down.dart';
import 'package:morched/constants/constants.dart';

class MarketSignUp extends StatelessWidget {
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController mdps_controller = TextEditingController();
  TextEditingController conf_mdps_controller = TextEditingController();
  MarketSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(120, 255, 175, 55),
              Color.fromARGB(120, 180, 87, 173),
              Color.fromARGB(120, 255, 87, 199),
            ],
          ),
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 260,
              ),
              const Text(
                'Proposer votre Service:',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const MySpace(factor: 0.02),
              CustomTextField(
                labelText: 'E-mail',
                prefixIcon: Icons.email_rounded,
                controller: email_controller,
                keyboardType: TextInputType.emailAddress,
              ),
              const MySpace(factor: 0.05),
              CustomTextField(
                labelText: 'Mot De Pass',
                prefixIcon: Icons.lock,
                controller: mdps_controller,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
              const MySpace(factor: 0.05),
              CustomTextField(
                labelText: 'Confirmer Mot De Pass',
                prefixIcon: Icons.password_rounded,
                controller: conf_mdps_controller,
                obscureText: true,
              ),
              const MySpace(factor: 0.05),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const MarketSignUp2(),
                    ),
                  );
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(6.0),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                ),
                child: const Text(
                  'Suivant',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Avez-vous déja un compte ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text("se Connecter")),
                ],
              )
            ],
          ),
        ),
      )
    ]));
  }
}

class MarketSignUp2 extends StatefulWidget {
  const MarketSignUp2({super.key});

  @override
  State<MarketSignUp2> createState() => _MarketSignUp2State();
}

class _MarketSignUp2State extends State<MarketSignUp2> {
  TextEditingController nom_Controller = TextEditingController();

  TextEditingController adresse_Controller = TextEditingController();

  TextEditingController phone_Controller = TextEditingController();

  TextEditingController confMdpsController = TextEditingController();

  io.File? image;
  io.File? _profileImage;

  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _initialCameraPosition = const LatLng(0, 0);
  late LatLng _selectedLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show dialog to enable location services
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Services Disabled'),
            content: const Text(
                'Please enable location services to use this feature.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permission is denied, request permission from the user
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permission is still denied, show dialog to request permission again
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location Permission Denied'),
              content: const Text(
                  'Please grant location permission to use this feature.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    // Location permission is granted, get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      // Initialize _initialCameraPosition with the current position
      _initialCameraPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _selectLocation(LatLng position) async {
    setState(() {
      _selectedLocation = position;
    });

    // Do something with the selected location, like updating the form field
    // You can also close the map here if needed
  }

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = io.File(image.path); // Use 'io.File' with the prefix
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = io.File(image.path); // Use 'io.File' with the prefix
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(180, 255, 175, 55),
                Color.fromARGB(190, 180, 87, 173),
                Color.fromARGB(120, 255, 87, 199),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              GestureDetector(
                  onTap: getImage,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90000),
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.add_photo_alternate,
                                  size: 50),
                            ),
                    ),
                  )),
              const SizedBox(height: 20),
              const Text(
                'Proposer votre Service:',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const MySpace(factor: 0.02),
              CustomTextField(
                labelText: 'Nom',
                prefixIcon: Icons.store,
                controller: nom_Controller,
                keyboardType: TextInputType.emailAddress,
              ),
              const MySpace(factor: 0.05),

              IconButton(
                icon: const Icon(Icons.local_post_office_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: SizedBox(
                          height: 300,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _initialCameraPosition,
                              zoom: 15,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            onTap: _selectLocation,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // Column(
              //   children: [
              //     CustomTextField(
              //       labelText: 'Adresse',
              //       prefixIcon: Icons.location_on,
              //       controller: adresse_Controller,
              //       obscureText: true,
              //       keyboardType: TextInputType.visiblePassword,
              //     ),
              //     // You can add additional widgets below if needed
              //   ],
              // ),

              const MySpace(factor: 0.05),
              CustomTextField(
                labelText: 'Numéro de télèphone',
                prefixIcon: Icons.phone,
                controller: phone_Controller,
                obscureText: true,
              ),
              const MySpace(factor: 0.05),
              Dropyy(hintText: 'Category', dropItems: categories),
              const MySpace(factor: 0.05),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(6.0),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryColor),
                ),
                child: const Text(
                  'Inscrire',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Avez-vous déja un compte ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text("se Connecter")),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
