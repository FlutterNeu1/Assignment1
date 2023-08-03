import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf_application/view/homepage.dart';
import 'package:pdf_application/view/login.dart';
import 'package:pdf_application/view/signup.dart';

import 'controller/errorcontroller.dart';
import 'controller/productcontroller.dart';
import 'controller/authcontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ProductController());
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _authController.user.value == null ? '/' : '/home',
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/signup', page: () => SignupPage()),
        GetPage(
          name: '/home',
          page: () => ErrorController(
            // Wrap MyHomePage with ErrorController
            child: MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ),
      ],
    );
  }
}
