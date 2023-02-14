import 'package:assingment/Authentication/login_register.dart';
import 'package:assingment/Splash/splash_screen.dart';
import 'package:assingment/screen/cities_page.dart';
import 'package:assingment/screen/home_page.dart';
import 'package:assingment/screen/overview_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCrSwVB12UIZ_wiLcsIqDeXb3cP6QKkMgM",
    appId: "1:787886302853:web:13c091d145a43e42c26bec",
    messagingSenderId: "787886302853",
    storageBucket: "tp-zap-solz.appspot.com",
    projectId: "tp-zap-solz",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'ibmPlexSans',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        dividerColor: const Color.fromARGB(255, 2, 42, 75),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: blue),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: blue)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusColor: Colors.black,
          // labelStyle: Colors.b
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  // void initState() {
  //   super.initState();
  //   bool user = FirebaseAuth.instance.currentUser == null;
  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => user ? const LoginRegister() : const HomePage(),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return
        // CitiesPage();
        // OverviewPage(
        //   depoName: 'sdsa',
        // );
        const SplashScreen();
  }
}
