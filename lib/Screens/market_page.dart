import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/constants/constants.dart';

class MarketPage extends StatelessWidget {
  final String name;
  const MarketPage({
    super.key,
    required this.name,
  });

  Future<Map<String, dynamic>?> _getUserData(String name) async {
    try {
      // Query Firestore collection for user with matching name
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('normal_users')
              .where('name', isEqualTo: name)
              .limit(1) // Limit to 1 document (assuming name is unique)
              .get();

      // Check if any document is found
      if (querySnapshot.docs.isNotEmpty) {
        // Extract user data from the first document
        Map<String, dynamic> userData = querySnapshot.docs.first.data();
        return userData;
      } else {
        // No user found with the provided name
        print('No user found with the name: $name');
        return null;
      }
    } catch (e) {
      // Error occurred while fetching user data
      print('Error fetching user data: $e');
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
          future: _getUserData(name),
          builder:
              (context, AsyncSnapshot<Map<String, dynamic>?> userDataSnapshot) {
            if (userDataSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (userDataSnapshot.hasError) {
              return Text('Error: ${userDataSnapshot.error}');
            }
            final userData = userDataSnapshot.data;
            final userName = userData?['name'] ?? 'User';
            final profileImageUrl =
                userData?['profileImageUrl'] ?? 'assets/girl.jpg';
            final phoneNumber = userData?['phoneNumber'] ?? '';
            final imageUrls = userData?['imageUrls'] ?? [];

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
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: CircleAvatar(
                                  backgroundImage: profileImageUrl != null
                                      ? NetworkImage(profileImageUrl)
                                      : const AssetImage('assets/girl.jpg')
                                          as ImageProvider,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                            ],
                          ),
                        ),
                        const MySpace(factor: 0.07),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Take a look',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const MySpace(factor: 0.001),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imageUrls.length,
                            itemBuilder: (BuildContext context, int index) {
                              final imageUrl = imageUrls[index];
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: 250,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.0, left: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: CircleAvatar(),
                                            ),
                                            MySpace(factor: 0.02),
                                            Column(
                                              children: [
                                                Text(
                                                  'Aliana bingosal',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 15),
                                          child: Text(
                                            "Dans Google Maps, vous pouvez rédiger des avis sur les lieux que vous visitez. Vous pouvez également ajouter des informations, ou publier de nouvelles photos ou vidéos (par exemple, pour indiquer si l'endroit est calme, romantique ou en travaux).",
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
