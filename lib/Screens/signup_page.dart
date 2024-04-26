// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:morched/Components/customfield.dart';
import 'package:morched/constants/constants.dart';

class SignUpPage extends StatelessWidget {
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController mdps_controller = TextEditingController();
  TextEditingController conf_mdps_controller = TextEditingController();
  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 260,
            ),
            CustomTextField(
              labelText: 'Nom & Prénom',
              prefixIcon: Icons.person,
              controller: name_controller,
            ),
            const MySpace(factor: 0.08),
            CustomTextField(
              labelText: 'E-mail',
              prefixIcon: Icons.email_rounded,
              controller: email_controller,
              keyboardType: TextInputType.emailAddress,
            ),
            const MySpace(factor: 0.08),
            CustomTextField(
              labelText: 'Mot De Pass',
              prefixIcon: Icons.lock,
              controller: mdps_controller,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const MySpace(factor: 0.08),
            CustomTextField(
              labelText: 'Confirmer Mot De Pass',
              prefixIcon: Icons.password_rounded,
              controller: conf_mdps_controller,
              obscureText: true,
            ),
            const MySpace(factor: 0.08),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(6.0),
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
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
                const Text("Vous avez déja un compte ?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text("Connecter Maintenant")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
