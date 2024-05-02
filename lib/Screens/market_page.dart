import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/constants/constants.dart';

class MarketPage extends StatelessWidget {
  final String name;
  final TextEditingController commentController = TextEditingController();

  MarketPage({
    super.key,
    required this.name,
  });

  Future<List<Map<String, dynamic>>> _fetchComments() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('market_comments')
              .doc(name)
              .collection('comments')
              .orderBy('timestamp',
                  descending: true) // Order comments by timestamp
              .get();

      // Check if any comments are found
      if (querySnapshot.docs.isNotEmpty) {
        // Extract comments data
        List<Map<String, dynamic>> comments = [];
        for (final doc in querySnapshot.docs) {
          // Fetch user data for each comment
          final userId = doc['userId'];
          final userData = await _getUsersData(userId);
          final commentData = doc.data();
          // Add user data to comment
          commentData['userName'] = userData?['name'] ?? 'User';
          commentData['profileImageUrl'] = userData?['profileImageUrl'] ?? '';
          comments.add(commentData);
        }
        return comments;
      } else {
        // No comments found
        return [];
      }
    } catch (e) {
      // Handle errors here
      print('Error fetching comments: $e');
      return [];
    }
  }

  Future<void> _addComment(String comment) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Add the comment to Firestore
        await FirebaseFirestore.instance
            .collection('market_comments')
            .doc(name)
            .collection('comments')
            .add({
          'userId': user.uid,
          'comment': comment,
          'timestamp': Timestamp.now(),
        });
      }
    } catch (e) {
      // Handle errors here
      print('Error adding comment: $e');
    }
  }

  Future<Map<String, dynamic>?> _getUsersData(String userId) async {
    try {
      // Query Firestore collection for user with matching ID
      DocumentSnapshot<Map<String, dynamic>> userDataSnapshot =
          await FirebaseFirestore.instance
              .collection('normal_users')
              .doc(userId)
              .get();

      // Check if document exists
      if (userDataSnapshot.exists) {
        // Extract user data
        Map<String, dynamic> userData = userDataSnapshot.data()!;
        return userData;
      } else {
        // User not found
        print('User not found with the ID: $userId');
        return null;
      }
    } catch (e) {
      // Error occurred while fetching user data
      print('Error fetching user data: $e');
      return null;
    }
  }

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
          return const IndicatorWait();
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
              return const IndicatorWait();
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
                        // Display other data before comments section
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
                        // Display images
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
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child:
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                  future: _fetchComments(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const IndicatorWait();
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    final comments = snapshot.data;
                                    if (comments == null || comments.isEmpty) {
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
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final comment = comments[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              width: 250,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(comment[
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
                                                      padding: const EdgeInsets
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
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: commentController,
                                        decoration: InputDecoration(
                                          hintText: 'Add a comment...',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () {
                                        _addComment(commentController.text);
                                        commentController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
