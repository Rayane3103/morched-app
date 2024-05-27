import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/Screens/login_page.dart';
import 'package:morched/constants/constants.dart';
import 'package:morched/fire_services.dart';
import 'package:morched/waiter.dart';

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

  Future<List<Map<String, dynamic>>> _fetchComments(String uid) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('market_comments')
              .doc(uid)
              .collection('comments')
              .orderBy('timestamp',
                  descending: true) // Order comments by timestamp
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> comments = [];
        for (final doc in querySnapshot.docs) {
          final userId = doc['userId'];
          final userData = await _getUserData(userId);
          final commentData = doc.data();
          commentData['userName'] = userData?['name'] ?? 'User';
          commentData['profileImageUrl'] = userData?['profileImageUrl'] ?? '';
          comments.add(commentData);
        }
        return comments;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> _addComment(String uid, String comment) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('market_comments')
            .doc(uid)
            .collection('comments')
            .add({
          'userId': user.uid,
          'comment': comment,
          'timestamp': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error adding comment: $e');
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
            return const Text('User is not logged in');
          }

          return FutureBuilder<Map<String, dynamic>?>(
              future: _getUserData(user.uid),
              builder: (context,
                  AsyncSnapshot<Map<String, dynamic>?> userDataSnapshot) {
                if (userDataSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const WaitPage();
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
                                      backgroundImage: profileImageUrl != null
                                          ? NetworkImage(profileImageUrl)
                                          : const AssetImage('assets/girl.jpg')
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
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                AuthService auth = AuthService();
                                try {
                                  await auth.signOut();
                                  Navigator.pushReplacement<void, void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const LoginPage(),
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
                            if (imageUrls.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final imageUrl = imageUrls[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              width: 250,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                ],
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
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: FutureBuilder<
                                        List<Map<String, dynamic>>>(
                                      future: _fetchComments(user.uid),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        final comments = snapshot.data;
                                        if (comments == null ||
                                            comments.isEmpty) {
                                          return const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                              'No comments yet',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }
                                        return Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: comments.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final comment = comments[index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Container(
                                                  width: 250,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0,
                                                                left: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      comment[
                                                                          'profileImageUrl']),
                                                              radius: 20,
                                                            ),
                                                            const MySpace(
                                                                factor: 0.02),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  comment[
                                                                      'userName'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 20.0,
                                                          ),
                                                          child: Text(
                                                            comment['comment'],
                                                            softWrap: true,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(15.0),
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: TextField(
                                  //           controller: commentController,
                                  //           decoration: InputDecoration(
                                  //             hintText: 'Add a comment...',
                                  //             border: OutlineInputBorder(
                                  //               borderRadius: BorderRadius.circular(30),
                                  //             ),
                                  //           ),
                                  //           onChanged: (value) {},
                                  //         ),
                                  //       ),
                                  //       IconButton(
                                  //         icon: const Icon(Icons.send),
                                  //         onPressed: () {
                                  //           _addComment(user.uid, commentController.text);
                                  //           commentController.clear();
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
