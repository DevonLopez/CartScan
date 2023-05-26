import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/services/list_service.dart';
import 'package:cart_scan/services/product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cart_scan/providers/providers.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:cart_scan/widgets/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var barcode = '';
  bool _isDataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);

    if (!_isDataFetched) {
      print('peticion de usuarios con listas base');
      userProvider.getCurrentUserWithLists();
      _isDataFetched = true;
    }
  }

  void _performAPICall() async {
    final response = await fetchProductData(barcode);
    if (response != null) {
      print(response.title); // Muestra la respuesta en la consola
    } else {
      print(
          'Error: Respuesta nula'); // Muestra un mensaje de error si la respuesta es nula
    }
  }

  Future<void> openBarcodeScanner() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000', // Color de la barra de escaneo
      'Cancelar', // Texto del botón de cancelar
      false, // Desactivar el flash
      ScanMode.DEFAULT, // Modo de escaneo predeterminado
    );

    // Guardar el barcode obtenido
    // Aquí puedes hacer lo que necesites con el valor del barcode, como guardarlo en Firebase
    this.barcode = barcode;

    // Volver a la pantalla DetailsScreen
    Navigator.of(context).pop();
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 226, 88),
        title: Text('${tituloCabecera}'),
      ),
      endDrawer: const SideMenu(),
      body: _DetailsScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            elevation: 2,
            backgroundColor: Color.fromARGB(255, 150, 226, 88),
            child: Icon(Icons.filter_center_focus),
            onPressed: openBarcodeScanner,
          ),
        ],
      ),
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
