import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:morched/Screens/add_images.dart';
import 'package:morched/Screens/home_page.dart';
import 'package:morched/Screens/login_page.dart';
import 'package:morched/Screens/profile_page.dart';
import 'package:morched/Screens/signup_page.dart';
import 'package:morched/Screens/welcome_page.dart';
import 'package:morched/firebase_options.dart';
import 'package:morched/waiter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Jaldi'),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const WaitPage();
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    print('user is currently signed in');
                    return const HomePage();
                  } else {
                    return const WelcomePage();
                  }
                }
              },
            ),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/add': (context) => const AddMarketImages(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/welcome': (context) => const WelcomePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
