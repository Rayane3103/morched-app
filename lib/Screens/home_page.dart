import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/Screens/map_page.dart';
import 'package:morched/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });
  void _onCategoryTap(BuildContext context, String category) {
    FirebaseFirestore.instance
        .collection('normal_users')
        .where('category', isEqualTo: category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<Map<String, String>> userData = [];
      for (var doc in querySnapshot.docs) {
        // Extract user data
        final userName = doc['name'];
        final dynamic imageUrlsData = doc['imageUrls'];
        final List<String> imageUrls =
            (imageUrlsData as List<dynamic>).cast<String>();

        final String firstImageUrl = imageUrls[0];
        final String position = doc['position'];

        // Add user data to the list
        userData.add({
          'name': userName,
          'firstImageUrl': firstImageUrl,
          'position': position,
        });
      }

      // Navigate to the MapPage and pass the user data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(userData: userData),
        ),
      );
    }).catchError((error) {
      print('Failed to fetch users: $error');
    });
  }

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
            final profileImageUrl = userData?['profileImageUrl'];

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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/profile');
                              },
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                  backgroundImage: profileImageUrl != null
                                      ? NetworkImage(profileImageUrl)
                                      : const AssetImage('assets/girl.jpg')
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 47,
                        right: 40,
                        top: 320,
                        child: Container(
                            height: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              children: [
                                SizedBox(
                                    height: 170,
                                    child: Image.asset(
                                      'assets/Pub.png',
                                      fit: BoxFit.fill,
                                    )),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 8, right: 8),
                                  child: Column(
                                    children: [
                                      Text(
                                        'مرشد المواقيت',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'تطبيقنا دليلكم',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      Text(
                                        'أينما كنتم',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        top: 300,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50.0, right: 50, top: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Dateheure(
                                    text: "L'Heure",
                                    icon: Icons.schedule,
                                    onPressed: () {},
                                  ),
                                  Dateheure(
                                    text: "La Date",
                                    icon: Icons.calendar_month,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 100,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.45,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 27.0, right: 27, top: 20),
                            child: ListView(
                              children: [
                                GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: categories.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CategoryItem(
                                      category: categories[index],
                                      onTap: () {
                                        _onCategoryTap(
                                            context, categories[index]);
                                      },
                                      image: images[index],
                                      color: colors[index],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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

class Dateheure extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const Dateheure(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 50,
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  size: 30,
                  icon,
                  color: primaryColor,
                ),
              ),
              Text(
                text,
                style: const TextStyle(color: primaryColor, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String category;
  final VoidCallback onTap;
  final String image;
  final Color color;
  const CategoryItem(
      {super.key,
      required this.category,
      required this.onTap,
      required this.image,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Material(
          shadowColor: Colors.black,
          elevation: 7,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color.fromARGB(31, 206, 206, 206),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(90)),
                    height: 50,
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        color: Colors.white,
                        image,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  const MySpace(factor: 0.01),
                  Text(
                    category,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 71, 71, 71)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
