import 'package:cart_scan/providers/login_provider.dart';
import 'package:cart_scan/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class LogInScreen extends StatefulWidget {
  final Function()? onTap;
  const LogInScreen({super.key, required this.onTap});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _email = TextEditingController();

  final _constrasena = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 124, 190, 69),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/logoCart.png',
              fit: BoxFit.cover,
              cacheHeight: 200,
              cacheWidth: 220,
            ),
            fieldEmail(),
            const Divider(
              color: Color.fromARGB(0, 0, 0, 0),
            ),
            fieldPassword(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 180,
                  height: 50,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'Reset',
                        arguments: _email.text);
                  },
                  child: const Text('Olvidaste la contraseña?'),
                )
              ],
            ),
            MyButton(
              onTap: signIn,
              text: "Iniciar Sesión",
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No tienes cuenta?',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    'Haz click aquí!!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget fieldEmail() {
    return SizedBox(
      width: 340,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => email != null && EmailValidator.validate(email)
            ? null
            : 'Introduce un correo electrónico válido',
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 10),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 172, 248, 211),
        ),
      ),
    );
  }

  Widget fieldPassword(BuildContext context) {
    final passwProvider = Provider.of<LoginProvider>(context);

    return SizedBox(
      width: 340,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (valor) => valor != null && valor.length < 6
            ? 'Introduce un mínimo de 6 letras'
            : null,
        controller: _constrasena,
        obscureText: passwProvider.password,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 10),
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: IconButton(
            icon: Icon(passwProvider.password
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded),
            onPressed: () {
              passwProvider.actualizarContra();
            },
          ),
          filled: true,
          fillColor: const Color.fromARGB(255, 172, 248, 211),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _constrasena.dispose();
    super.dispose();
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(), password: _constrasena.text.trim());
    } on FirebaseAuthException {
      Utils.showSnackBar(
          "El correo electrónico o la contraseña no son correctos");
    }
  }
}
