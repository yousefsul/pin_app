import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'pinPage/PinPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of application.
  /*
    * bulid Method
    * * Create Animated splash screen widget and navigate to PinPage in pinPage package
    * * Add Image from assets folder named lock.png
  */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/lock.png'),
        nextScreen: PinPage(),
        splashTransition: SplashTransition.rotationTransition,
        backgroundColor: Colors.deepPurple[200]!,
      ),
    );
  }
}
