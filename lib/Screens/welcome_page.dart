import 'package:flutter/material.dart';
import 'package:morched/Screens/login_page.dart';
import 'package:morched/Screens/market_signup.dart';
import 'package:morched/Screens/signup_page.dart';
import 'package:morched/constants/constants.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                const Text(
                  'Save your time and know the best time for your appointment',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                ),
                const MySpace(factor: 0.1),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => MarketSignUp(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(10.0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 80.0),
                    ),
                  ),
                  child: const Text(
                    'Proposer Un Service',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                const MySpace(factor: 0.04),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SignUpPage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(10.0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 80.0),
                    ),
                  ),
                  child: const Text(
                    'Trouver Un Service',
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                        style: TextStyle(color: primaryColor),
                        'Avez-vous dèja un compte ? Se Connecter!'))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
