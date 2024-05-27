import 'package:flutter/material.dart';
import 'package:morched/Components/customfield.dart';
import 'package:morched/Screens/home_page.dart';
import 'package:morched/constants/constants.dart';
import 'package:morched/fire_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        errorMessage = null;
      });

      AuthService auth = AuthService();

      String? error = await auth.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (error != null) {
        // If login fails, set error message
        setState(() {
          errorMessage = 'Failed to login: $error';
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(120, 255, 175, 55),
                  Color.fromARGB(120, 180, 87, 173),
                  Color.fromARGB(120, 255, 87, 199),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  SizedBox(height: 260, child: Image.asset('assets/logo.png')),
                  CustomTextField(
                    labelText: 'E-mail',
                    prefixIcon: Icons.email_rounded,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const MySpace(factor: 0.05),
                  CustomTextField(
                    labelText: 'Mot de passe',
                    prefixIcon: Icons.lock,
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const MySpace(factor: 0.1),
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                  ElevatedButton(
                    onPressed: login,
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(6.0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryColor),
                    ),
                    child: const Text(
                      'Connecter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Pas de compte ?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/welcome');
                        },
                        child: const Text("Inscrivez-vous maintenant"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
