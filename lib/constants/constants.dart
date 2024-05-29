import 'package:flutter/material.dart';

const primaryColor = Color(0xFF8C3CB2);

List<String> categories = [
  'Alimentation',
  'Médecin',
  'Pharmacie',
  'GYM',
  'Coiffeur',
  'Coiffeuse',
  'Cosmétiques',
  'Restaurant',
  'Caféteria',
  'Avocat',
  'Vététinaire',
  'Boutique'
];
List<String> images = [
  'assets/icons/store.png',
  'assets/icons/doctor.png',
  'assets/icons/pharmacy.png',
  'assets/icons/gym.png',
  'assets/icons/barber.png',
  'assets/icons/coiffeuse.png',
  'assets/icons/cosmetic.png',
  'assets/icons/resto.png',
  'assets/icons/cafeteria.png',
  'assets/icons/law.png',
  'assets/icons/veterinary.png',
  'assets/icons/clothes.png',
];
List colors = [
  const Color.fromARGB(255, 201, 114, 0),
  const Color.fromARGB(255, 255, 42, 74),
  const Color.fromARGB(255, 31, 128, 44),
  const Color.fromARGB(255, 35, 35, 35),
  const Color.fromARGB(255, 83, 0, 156),
  const Color.fromARGB(255, 180, 85, 166),
  const Color.fromARGB(255, 127, 85, 255),
  const Color.fromARGB(255, 49, 134, 0),
  const Color.fromARGB(255, 117, 65, 0),
  const Color.fromARGB(255, 6, 0, 92),
  const Color.fromARGB(255, 195, 73, 184),
  const Color.fromARGB(255, 0, 95, 95),
];

class MySpace extends StatelessWidget {
  final double factor;

  const MySpace({super.key, required this.factor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * factor,
      width: MediaQuery.of(context).size.width * factor,
    );
  }
}

class IndicatorWait extends StatelessWidget {
  const IndicatorWait({super.key});

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
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png'),
              const CircularProgressIndicator(),
            ],
          ),
        )
      ]),
    );
  }
}
