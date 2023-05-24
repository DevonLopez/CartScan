import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cart_scan/providers/providers.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:cart_scan/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.getCurrentUserWithLists();
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        await GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Cerrar Sesión"),
      content: Text("Estas seguro que quieres cerrar sesión?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    final uiProvider = Provider.of<UIProvider>(context);

    final currentIndex = uiProvider.menuOpt;
    var tituloCabecera;
    if (currentIndex == 0)
      tituloCabecera = "Mis Listas";
    else if (currentIndex == 1)
      tituloCabecera = "Comparaciones";
    else if (currentIndex == 2)
      tituloCabecera = "Buscar artículos";
    else
      tituloCabecera = "Mis Listas";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 226, 88),
        title: Text('${tituloCabecera}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              openCreateListForm(context);
            },
          )
        ],
      ),
      body: _DetailsScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _DetailsScreenBody extends StatelessWidget {
  const _DetailsScreenBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    final currentIndex = uiProvider.menuOpt;

    switch (currentIndex) {
      case 0:
        return ListScreen();

      case 1:
        return CompareScreen();

      case 2:
        return SearchScreen();

      default:
        return ListScreen();
    }
  }
}

void openCreateListForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateListForm(); // Aquí debes crear y retornar tu formulario de creación de lista
    },
  );
}
