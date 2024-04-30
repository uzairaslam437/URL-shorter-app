import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vs/features/app/splash_screen/splash_screen.dart';
import 'package:flutter_vs/features/user_auth/presentation/pages/homepage.dart';
import 'package:flutter_vs/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_vs/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:flutter_vs/features/user_auth/presentation/pages/votepage.dart';
Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyBZKTZruUl3mpKBdTt3G573bUIasHjw-Cg", appId: "1:901647577074:web:06650ea9899db5f23d456b", messagingSenderId: "901647577074", projectId: "voting-system-b30a9"));
  }
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/vote' :(context) => VotingPage()
      },
    );
  }
}





