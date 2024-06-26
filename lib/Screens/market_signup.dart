import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:morched/Components/customfield.dart';
import 'package:morched/Components/drop_down.dart';
import 'package:morched/constants/constants.dart';
import 'package:morched/fire_services.dart';

class MarketSignUp2 extends StatefulWidget {
  final String email;
  final String password;

  const MarketSignUp2({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<MarketSignUp2> createState() => _MarketSignUp2State();
}

class _MarketSignUp2State extends State<MarketSignUp2> {
  final List<Marker> _markers = [];

  TextEditingController nom_Controller = TextEditingController();
  TextEditingController adresse_Controller = TextEditingController();
  TextEditingController phone_Controller = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _initialCameraPosition = const LatLng(0, 0);
  LatLng? _selectedLocation;
  late String _selectedCategory;
  TimeOfDay? startOfWork;
  TimeOfDay? endOfWork;
  List<String> selectedDays = [];
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 15);

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        startOfWork = newTime;
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        endOfWork = newTime;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
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
    print("Selected location: $position");

    // Create a new marker
    Marker newMarker = Marker(
      markerId: const MarkerId('selected-location'),
      position: position,
    );

    // Update the state to add the new marker
    setState(() {
      _selectedLocation = position;
      // Add the new marker to the existing set of markers
      _markers.add(newMarker);
    });

    // Show a snackbar with the selected location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Location selected: (${position.latitude}, ${position.longitude})'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                Image.asset(
                  'assets/logo.png',
                  height: 150,
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
                  labelText: 'Nom',
                  prefixIcon: Icons.store,
                  controller: nom_Controller,
                  keyboardType: TextInputType.emailAddress,
                ),
                const MySpace(factor: 0.05),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                              child: SizedBox(
                                  height: 300, // Set the height of the map
                                  child: GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: _initialCameraPosition,
                                      zoom: 15,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      if (!_controller.isCompleted) {
                                        _controller.complete(controller);
                                      }
                                    },
                                    onTap: (LatLng latlng) {
                                      _selectLocation(latlng);
                                    },
                                    markers: _markers.toSet(),
                                  )));
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: primaryColor,
                          ),
                          MySpace(factor: 0.0335),
                          Text('Ajouter la position du votre service'),
                        ],
                      ),
                    ),
                  ),
                ),
                const MySpace(factor: 0.05),
                CustomTextField(
                  labelText: 'Numéro de télèphone',
                  prefixIcon: Icons.phone,
                  controller: phone_Controller,
                  obscureText: false,
                ),
                const MySpace(factor: 0.05),
                Dropyy(
                  hintText: 'Category',
                  dropItems: categories,
                  onChanged: (selectedCategory) {
                    setState(() {
                      _selectedCategory = selectedCategory;
                    });
                  },
                ),
                const MySpace(factor: 0.05),
                Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      showDialog<List<String>>(
                        context: context,
                        builder: (BuildContext context) {
                          return WeekdaySelectorDialog(
                              selectedDays: selectedDays);
                        },
                      ).then((selectedList) {
                        if (selectedList != null) {
                          setState(() {
                            selectedDays = selectedList;
                          });
                          print('Selected Days: $selectedDays');
                        }
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: primaryColor,
                          ),
                          MySpace(factor: 0.0335),
                          Text('Ajouter les jours de travailles'),
                        ],
                      ),
                    ),
                  ),
                ),
                const MySpace(
                  factor: 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            _selectStartTime();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.alarm,
                                  color: primaryColor,
                                ),
                                MySpace(factor: 0.0335),
                                Text('Début'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: InkWell(
                          onTap: () {
                            _selectEndTime();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.alarm_off,
                                  color: primaryColor,
                                ),
                                MySpace(factor: 0.0335),
                                Text("Fin"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      AuthService authService = AuthService();
                      dynamic result = await authService
                          .signUpWithEmailAndPasswordForMarketUser(
                        widget.email,
                        widget.password,
                        nom_Controller.text,
                        _selectedLocation.toString(),
                        phone_Controller.text,
                        _selectedCategory,
                        startOfWork!,
                        endOfWork!,
                        selectedDays,
                      );

                      if (result != null) {
                        Navigator.pushReplacementNamed(context, '/add');
                      } else {}
                    } catch (e) {
                      print('Error signing up: $e');
                      return;
                    }
                  },
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Avez-vous déjà un compte ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text("Se Connecter"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
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
                onPressed: () async {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MarketSignUp2(
                        email: email_controller.text,
                        password: mdps_controller.text,
                      ),
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
                    fontWeight: FontWeight.bold,
                  ),
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

class WeekdaySelectorDialog extends StatefulWidget {
  final List<String> selectedDays;

  const WeekdaySelectorDialog({
    super.key,
    required this.selectedDays,
  });

  @override
  _WeekdaySelectorDialogState createState() => _WeekdaySelectorDialogState();
}

class _WeekdaySelectorDialogState extends State<WeekdaySelectorDialog> {
  late List<String> selectedDays;

  final List<String> weekdays = [
    'Samedi',
    'Dimanche',
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
  ];

  @override
  void initState() {
    super.initState();
    selectedDays = List<String>.from(widget.selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Weekdays'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: weekdays.map((day) {
            bool isSelected = selectedDays.contains(day);
            return CheckboxListTile(
              title: Text(day),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value != null && value) {
                    selectedDays.add(day);
                  } else {
                    selectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedDays);
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
