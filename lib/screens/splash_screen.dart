import 'dart:async';

import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _SplashScreenState() {
    new Timer(Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DetailsScreen()),
            (route) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color actionColor = Color.fromARGB(255, 150, 226, 88);
    Color backColor = Color.fromARGB(255, 248, 246, 117);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [actionColor, backColor],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: size.height * 0.45,
            width: size.width * 0.45,
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  "assets/logoCart.png",
                  cacheHeight: (size.height * 0.3).round(),
                  cacheWidth: (size.width * 0.5).round(),
                ),
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2.0,
                    offset: Offset(5.0, 3.0),
                    spreadRadius: 2.0,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
