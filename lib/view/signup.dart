import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/authcontroller.dart';

class SignupPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Please Sign up!",
                style: TextStyle(
                    fontSize: 32,
                    color: Color.fromARGB(255, 125, 0, 241),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Oswald-Regular"),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  enabled: true,
                  label: const Text(
                    "Email",
                    style: TextStyle(fontFamily: "Oswald-Regular"),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabled: true,
                  label: const Text(
                    "Password",
                    style: TextStyle(fontFamily: "Oswald-Regular"),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(255, 179, 179, 179)),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _authController.signUp(
                  emailController.text,
                  passwordController.text,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 125, 0, 241),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size(double.infinity, 50)),
                ),
                child: const Text(
                  'Signup',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
