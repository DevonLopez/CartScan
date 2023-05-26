import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/login_provider.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:cart_scan/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();

  final _constrasena = TextEditingController();

  final _name = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _constrasena.dispose();
    super.dispose();
  }

  Future signUp() async {
    final esValid = _key.currentState!.validate();
    if (!esValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _constrasena.text.trim());
      addUserToCollection(_name.text);
    } on FirebaseAuthException {
      Utils.showSnackBar(
          "El correo electrónico que has introducido ya está en uso");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 124, 190, 69),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
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
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  'Completa los siguientes campos:',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              fieldName(),
              const Divider(
                color: Color.fromARGB(0, 255, 255, 255),
              ),
              fieldEmail(),
              const Divider(
                color: Color.fromARGB(0, 255, 255, 255),
              ),
              fieldPassword(context),
              const Divider(
                color: Color.fromARGB(0, 255, 255, 255),
              ),
              MyButton(
                onTap: signUp,
                text: "Registrar",
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Ya tienes cuenta?',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Inicia sesión',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldName() {
    return SizedBox(
      width: 340,
      child: TextFormField(
        controller: _name,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (text) {
          if (text!.isEmpty) {
            return "El nombre es un campo obligatorio";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Nombre de usuario',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
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
            : 'Introduce un correo electrónico valido',
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
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
            ? 'Introduce un mínimo de 6 caracteres'
            : null,
        controller: _constrasena,
        obscureText: passwProvider.password,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 3),
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
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
