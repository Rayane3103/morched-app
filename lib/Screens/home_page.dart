import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:morched/Components/slider.dart';
import 'package:morched/constants/constants.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

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
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/bggg.png'),
          //     fit: BoxFit.cover, // Zoomed in to cover the container
          //     alignment: Alignment.center, // Center the image
          //   ),
          // ),
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chahinez Morsli',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/girl.jpg'),
                      ))
                ],
              ),
            ),
            Positioned(
              left: 47,
              right: 40,
              top: 320,
              child: Container(
                  height: 170,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    children: [
                      SizedBox(
                          height: 170,
                          child: Image.asset(
                            'assets/Pub.png',
                            fit: BoxFit.fill,
                          )),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                        child: Column(
                          children: [
                            Text(
                              'مرشد المواقيت',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'تطبيقنا دليلكم',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w200),
                            ),
                            Text(
                              'أينما كنتم',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w200),
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
                padding: const EdgeInsets.only(left: 50.0, right: 50, top: 15),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 20),
                  child: ListView(
                    children: [
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                        ),
                        itemCount: categories.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryItem(
                            category: categories[index],
                            onTap: () {},
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
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: MySlider(),
            )
          ],
        ),
      ]),
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
            height: 100,
            width: 100,
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
