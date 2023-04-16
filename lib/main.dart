import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:torrentx/screens/home.dart';
import 'firebase_options.dart';
import 'package:torrentx/screens/login.dart';
import 'package:torrentx/screens/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        name: "TorrentX", options: DefaultFirebaseOptions.currentPlatform);
  } else {
    Firebase.app();
  }
  var user = FirebaseAuth.instance.currentUser;
  var initialRoute = user == null ? '/' : '/home';
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  // This widget is the root of your application.~
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => const Login()),
        GetPage(name: '/register', page: () => const Register()),
        GetPage(name: '/home', page: () => const Home()),
      ],
    );
  }
}
