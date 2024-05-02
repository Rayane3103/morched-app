import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morched/Screens/map_page.dart';
import 'package:morched/constants/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _onCategoryTap(BuildContext context, String category, String selectedDay,
      TimeOfDay selectedTime) async {
    final selectedTimeOfDay = selectedTime; // Store selectedTime
    FirebaseFirestore.instance
        .collection('normal_users')
        .where('category', isEqualTo: category)
        .where('daysOfWork', arrayContains: selectedDay)
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
        final startOfWorkHour = TimeOfDay(
          hour: int.parse(doc['startOfWorkHour'].split(':')[0]),
          minute: int.parse(doc['startOfWorkHour'].split(':')[1]),
        );
        final endOfWorkHour = TimeOfDay(
          hour: int.parse(doc['endOfWorkHour'].split(':')[0]),
          minute: int.parse(doc['endOfWorkHour'].split(':')[1]),
        );

        // Perform client-side comparison for endOfWorkHour
        if (_isTimeOfDayBeforeOrEqualTo(startOfWorkHour, selectedTimeOfDay) &&
            _isTimeOfDayAfterOrEqualTo(endOfWorkHour, selectedTimeOfDay)) {
          // Add user data to the list
          userData.add({
            'name': userName,
            'firstImageUrl': firstImageUrl,
            'position': position,
          });
        }
      }

      // Navigate to the MapPage and pass the user data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(userData: userData),
        ),
      );
    }).catchError((error) {
      print('Failed to fetch users: $error');
    });
  }

  bool _isTimeOfDayBeforeOrEqualTo(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) {
      return true;
    } else if (time1.hour == time2.hour) {
      return time1.minute <= time2.minute;
    } else {
      return false;
    }
  }

  bool _isTimeOfDayAfterOrEqualTo(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour > time2.hour) {
      return true;
    } else if (time1.hour == time2.hour) {
      return time1.minute >= time2.minute;
    } else {
      return false;
    }
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

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay? selectedTime;
  String? selectedDay;
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        selectedTime = newTime;
      });
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
          future: _getUserData(user.uid),
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
            final profileImageUrl = userData?['profileImageUrl'];

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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40, bottom: 10, right: 40, top: 40),
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
                            Navigator.pushNamed(context, '/profile');
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
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 47, right: 40, top: 10),
                    child: SizedBox(
                      height: 170,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 170,
                              child: Image.asset(
                                'assets/Pub.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.only(top: 20, left: 8, right: 8),
                              child: Column(
                                children: [
                                  Text(
                                    'مرشد المواقيت',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'تطبيقنا دليلكم',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                  Text(
                                    'أينما كنتم',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 30, right: 30),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Dateheure(
                              text: "L'Heure",
                              icon: Icons.schedule,
                              onPressed: _selectTime,
                            ),
                            Dateheure(
                              text: "La Date",
                              icon: Icons.calendar_month,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const WeekdaySelector();
                                  },
                                ).then((selectedList) {
                                  if (selectedList != null) {
                                    setState(() {
                                      selectedDay = selectedList;
                                    });
                                    print('Selected Day: $selectedDay');
                                    // Do whatever you want with the selected days
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 27.0, right: 27, top: 7),
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
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryItem(
                                  category: categories[index],
                                  onTap: () {
                                    if (selectedDay == null ||
                                        selectedTime == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Veuillez sélectionner le jour et l\'heure avant de choisir une catégorie.'),
                                        ),
                                      );
                                    } else {
                                      _onCategoryTap(
                                        context,
                                        categories[index],
                                        selectedDay!,
                                        selectedTime!,
                                      );
                                    }
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
            ]));
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

class WeekdaySelector extends StatefulWidget {
  const WeekdaySelector({super.key});

  @override
  _WeekdaySelectorState createState() => _WeekdaySelectorState();
}

class _WeekdaySelectorState extends State<WeekdaySelector> {
  String? selectedDay;

  final List<String> weekdays = [
    'Samedi',
    'Dimanche',
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Weekday'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: weekdays.map((day) {
            bool isSelected = selectedDay == day;
            return RadioListTile<String>(
              title: Text(day),
              value: day,
              groupValue: selectedDay,
              onChanged: (String? value) {
                setState(() {
                  selectedDay = value;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedDay);
          },
          child: const Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
