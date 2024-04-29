import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:morched/Screens/home_page.dart';
import 'package:morched/Screens/login_page.dart';
import 'package:morched/Screens/map_page.dart';
import 'package:morched/Screens/market_signup.dart';
import 'package:morched/Screens/signup_page.dart';
import 'package:morched/Screens/welcome_page.dart';
import 'package:morched/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Jaldi'),
      routes: {
        '/': (context) => const WelcomePage(),
        '/home': (context) => const HomePage(),
        '/map': (context) => const MapPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/marketsignup': (context) => MarketSignUp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}