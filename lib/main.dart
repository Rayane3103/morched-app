import 'package:flutter/material.dart';
import 'package:morched/Screens/market_signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MarketSignUp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/*theme: ThemeData(fontFamily: 'Jaldi'),
      routes: {
        '/': (context) => const WelcomePage(), 
        '/login': (context) => LoginPage(), 
        '/signup': (context) => SignUpPage(), 
      }, */