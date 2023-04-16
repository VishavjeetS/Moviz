import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:torrentx/controller/firebase_auth_controller.dart';

import '../controller/tmdb_auth_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Login"),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => _authController.loginUser(
                      _emailController.text.trim(),
                      _passwordController.text.trim()),
                  child: Obx(
                    () => _authController.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  )),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/register');
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
