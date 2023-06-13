import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class ResetScreen extends StatelessWidget {
  final _email = TextEditingController();
  ResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 111, 173, 60),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 79, 145, 25),
        title: const Text("Recuperar contraseña"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          fieldEmail(),
          SizedBox(
            height: 10,
          ),
          MyButton(
            onTap: () {
              FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
              Navigator.pop(context);
            },
            text: "Enviar email",
          )
        ],
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
            : 'Introduce un email valido',
        decoration: InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 10),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
