import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/Screens/login_page.dart';
import 'package:morched/constants/constants.dart';
import 'package:morched/fire_services.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _getUserData(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('normal_users')
          .doc(uid)
          .get();
      return snapshot.data();
    } catch (e) {
      print('Failed to get user data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final user = snapshot.data;
          if (user == null) {
            // User is not logged in
            return const Text('User is not logged in');
          }

          return FutureBuilder<Map<String, dynamic>?>(
              future: _getUserData(user.uid),
              builder: (context,
                  AsyncSnapshot<Map<String, dynamic>?> userDataSnapshot) {
                if (userDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (userDataSnapshot.hasError) {
                  return Text('Error: ${userDataSnapshot.error}');
                }
                final userData = userDataSnapshot.data;
                final userName = userData?['name'] ?? 'User';
                final profileImageUrl = userData?['profileImageUrl'];
                final phoneNumber = userData?['phoneNumber'];
                final imageUrls = userData?['imageUrls'];
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
                      padding: const EdgeInsets.only(top: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: CircleAvatar(
                                          backgroundImage: profileImageUrl !=
                                                  null
                                              ? NetworkImage(profileImageUrl)
                                              : const AssetImage(
                                                      'assets/girl.jpg')
                                                  as ImageProvider,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userName,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                size: 18,
                                              ),
                                              Text(
                                                phoneNumber,
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ])),
                            ElevatedButton(
                              onPressed: () async {
                                AuthService auth = AuthService();

                                try {
                                  await auth
                                      .signOut(); // Wait for sign-out to complete

                                  // Sign-out successful, navigate to login page
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          LoginPage(),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error during LogingOUT: $e');
                                }
                              },
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.all<double>(6.0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        primaryColor),
                              ),
                              child: const Text(
                                'Déconnecter',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]))
                ]));
              });
        });
  }
}
