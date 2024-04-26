// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      body: Padding(
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
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
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

  File? image;
  File? _profileImage;
  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
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
                child: image != null
                    ? Image.file(
                        image!,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: const Icon(Icons.add_photo_alternate, size: 50),
                      ),
              ),
              SizedBox(
                height: 75,
                width: 75,
                child: CircleAvatar(
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ajouter une photo de profil'),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: getProfileImage,
                  ),
                ],
              ),
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
              CustomTextField(
                labelText: 'Adresse',
                prefixIcon: Icons.location_on,
                controller: adresse_Controller,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
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
      ]),
    );
  }
}





// class MarketSignUp2 extends StatelessWidget {
//   TextEditingController name_controller = TextEditingController();
//   TextEditingController email_controller = TextEditingController();
//   TextEditingController mdps_controller = TextEditingController();
//   TextEditingController conf_mdps_controller = TextEditingController();
//   MarketSignUp2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Color.fromARGB(180, 255, 175, 55),
//                 Color.fromARGB(190, 180, 87, 173),
//                 Color.fromARGB(120, 255, 87, 199),
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: ListView(
//             children: [
//               Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       color: Colors.white,
//                     ),
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     height: MediaQuery.of(context).size.height * 0.2,
//                   )),
//               const SizedBox(
//                 height: 75,
//                 width: 75,
//                 child: CircleAvatar(),
//               ),
//               const MySpace(factor: 0.02),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Ajouter une photo profile'),
//                 ],
//               ),
//               const Text(
//                 'Proposer votre Service:',
//                 style: TextStyle(
//                     color: primaryColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold),
//               ),
//               const MySpace(factor: 0.02),
//               CustomTextField(
//                 labelText: 'Nom',
//                 prefixIcon: Icons.store,
//                 controller: email_controller,
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const MySpace(factor: 0.05),
//               CustomTextField(
//                 labelText: 'Adresse',
//                 prefixIcon: Icons.location_on,
//                 controller: mdps_controller,
//                 obscureText: true,
//                 keyboardType: TextInputType.visiblePassword,
//               ),
//               const MySpace(factor: 0.05),
//               CustomTextField(
//                 labelText: 'Numéro de télèphone',
//                 prefixIcon: Icons.phone,
//                 controller: conf_mdps_controller,
//                 obscureText: true,
//               ),
//               const MySpace(factor: 0.05),
//               Dropyy(hintText: 'Category', dropItems: categories),
//               const MySpace(factor: 0.05),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ButtonStyle(
//                   elevation: MaterialStateProperty.all<double>(6.0),
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(primaryColor),
//                 ),
//                 child: const Text(
//                   'Inscrire',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text("Vous avez déja un compte ?"),
//                   TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/login');
//                       },
//                       child: const Text("Connecter Maintenant")),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }

