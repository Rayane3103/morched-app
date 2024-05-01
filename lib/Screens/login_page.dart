import 'package:flutter/material.dart';
import 'package:morched/Components/customfield.dart';
import 'package:morched/Screens/home_page.dart';
import 'package:morched/constants/constants.dart';
import 'package:morched/fire_services.dart';

class LoginPage extends StatelessWidget {
  TextEditingController email_controller = TextEditingController();
  TextEditingController mdps_controller = TextEditingController();

  LoginPage({super.key});

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
                SizedBox(height: 260, child: Image.asset('assets/logo.png')),
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
                const MySpace(factor: 0.1),
                ElevatedButton(
                  onPressed: () async {
                    AuthService auth = AuthService();

                    try {
                      await auth.signInWithEmailAndPassword(
                          email_controller.text, mdps_controller.text);
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const HomePage(),
                        ),
                      );
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
                    'Connecter',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas du compte ?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text("Inscrire Maintenant"),
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
