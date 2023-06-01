import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/item_provider.dart';
import 'package:cart_scan/screens/item_screen.dart';
import 'package:cart_scan/services/product_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var barcodes = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);

    if (!userProvider.isDataFetch) {
      print('peticion de usuarios con listas base');
      userProvider.getCurrentUserWithLists();
      userProvider.isDataFetch = true;
    }
  }

  Future<Item> _performAPICall() async {
    final response = await fetchProductData(barcodes);
    print(response);
    if (response != null) {
      print(response.title);
      print(response.description);
      return Item(
          id: null,
          listId: null,
          description: response.description ?? '',
          name: response.title,
          price: 0.00,
          discount: 0,
          offer: false,
          quality: null);
    } else {
      print('Error: Respuesta nula');
      return Item(
          id: null,
          listId: null,
          name: '',
          description: '',
          price: 0.00,
          discount: 0,
          offer: false); // Muestra un mensaje de error si la respuesta es nula
    }
  }

  void openItemDetails(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemScreenForm(itemBarcode: item),
      ),
    );
  }

  Future<void> openBarcodeScanner() async {
    this.barcodes = '';
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000', // Color de la barra de escaneo
      'Cancelar', // Texto del botón de cancelar
      false, // Desactivar el flash
      ScanMode.BARCODE, // Modo de escaneo predeterminado
    );
    print('Codigo de barras: ${barcode}');

    if (barcode != '-1' && barcode.isNotEmpty) {
      this.barcodes = barcode;
      final provider = Provider.of<ItemFormProvider>(context, listen: false);
      provider.barcode = this.barcodes;

      // Llamar a la API y obtener la respuesta
      Item responseItem = await _performAPICall();

      // Crear un nuevo Item con los datos de la respuesta o valores por defecto

      print(this.barcodes);
      print(responseItem.toString());
      openItemDetails(responseItem);
    } else {
      Navigator.pushNamed(context, 'details');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        await GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Cerrar Sesión"),
      content: const Text("Estas seguro que quieres cerrar sesión?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    final uiProvider = Provider.of<UIProvider>(context);

    final currentIndex = uiProvider.menuOpt;
    String tituloCabecera;
    if (currentIndex == 0) {
      tituloCabecera = "Mis Listas";
    } else if (currentIndex == 1) {
      tituloCabecera = "Comparaciones";
    } else if (currentIndex == 2) {
      tituloCabecera = "Buscar artículos";
    } else {
      tituloCabecera = "Mis Listas";
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 150, 226, 88),
        title: Text(tituloCabecera),
      ),
      endDrawer: const SideMenu(),
      backgroundColor: Color.fromRGBO(248, 229, 165, 1),
      body: const _DetailsScreenBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            elevation: 2,
            backgroundColor: const Color.fromARGB(255, 150, 226, 88),
            onPressed: openBarcodeScanner,
            child: const Icon(Icons.filter_center_focus),
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
        return const ListScreen();

      case 1:
        return const CompareScreen();

      case 2:
        return SearchScreen();

      default:
        return const ListScreen();
    }
  }
}
