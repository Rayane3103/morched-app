// ignore_for_file: must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/Components/customfield.dart';
import 'package:morched/Screens/home_page.dart';
import 'package:morched/constants/constants.dart';
import 'package:morched/fire_services.dart';

class SignUpPage extends StatelessWidget {
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController mdps_controller = TextEditingController();
  TextEditingController conf_mdps_controller = TextEditingController();
  TextEditingController phoneNumber_controller = TextEditingController();
  SignUpPage({super.key});

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
                CustomTextField(
                  labelText: 'Nom & Prénom',
                  prefixIcon: Icons.person,
                  controller: name_controller,
                ),
                const MySpace(factor: 0.06),
                CustomTextField(
                  labelText: 'PhoneNumber',
                  prefixIcon: Icons.person,
                  controller: phoneNumber_controller,
                  obscureText: false,
                ),
                const MySpace(factor: 0.06),
                CustomTextField(
                  labelText: 'E-mail',
                  prefixIcon: Icons.email_rounded,
                  controller: email_controller,
                  keyboardType: TextInputType.emailAddress,
                ),
                const MySpace(factor: 0.06),
                CustomTextField(
                  labelText: 'Mot De Pass',
                  prefixIcon: Icons.lock,
                  controller: mdps_controller,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const MySpace(factor: 0.06),
                CustomTextField(
                  labelText: 'Confirmer Mot De Pass',
                  prefixIcon: Icons.password_rounded,
                  controller: conf_mdps_controller,
                  obscureText: true,
                ),
                const MySpace(factor: 0.06),
                ElevatedButton(
                  onPressed: () async {
                    AuthService auth = AuthService();

                    try {
                      User? user =
                          await auth.signUpWithEmailAndPasswordForNormalUser(
                        email_controller.text,
                        mdps_controller.text,
                        name_controller.text,
                        phoneNumber_controller.text,
                      );

                      if (user != null) {
                        // Sign-up successful, navigate to home page
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => const HomePage(),
                          ),
                        );
                      } else {
                        // Handle sign-up failure, such as showing an error message
                      }
                    } catch (e) {
                      // Handle any exceptions here, such as showing an error message
                      print('Error during sign up: $e');
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
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Avez-vous un compte ?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text("se Connecter")),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
