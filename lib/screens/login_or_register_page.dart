import 'package:cart_scan/screens/screens.dart';
import 'package:flutter/material.dart';

class LoginOrRegiserPage extends StatefulWidget {
  const LoginOrRegiserPage({super.key});

  @override
  State<LoginOrRegiserPage> createState() => _LoginOrRegiserPageState();
}

class _LoginOrRegiserPageState extends State<LoginOrRegiserPage> {
  bool mostrarSignInScreen = true;

  void cambiarPaginas() {
    setState(() {
      mostrarSignInScreen = !mostrarSignInScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mostrarSignInScreen) {
      return LogInScreen(
        onTap: cambiarPaginas,
      );
    } else {
      return RegisterScreen(
        onTap: cambiarPaginas,
      );
    }
  }
}
