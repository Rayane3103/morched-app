import 'package:flutter/material.dart';
import 'package:morched/constants/constants.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({super.key});

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
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            const MySpace(factor: 0.1),
            const CircularProgressIndicator(
              color: primaryColor,
            ),
          ],
        ),
      ))
    ]));
  }
}
