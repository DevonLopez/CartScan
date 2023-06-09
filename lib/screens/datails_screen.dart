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
  var barcode = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getItems();
    });
  }

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

  Future<void> _performAPICall() async {
    Product? response = await fetchProductData(barcode);
    final items = Provider.of<ItemFormProvider>(context, listen: false);
    print(response);
    if (response != null) {
      String descript = response.description;
      String name = response.title;
      items.scanned.description = descript;
      items.scanned.name = name;
      openItemDetails(items.scanned);
      print(items.scanned.toString());
    } else {
      print('Error: Respuesta nula');
      openItemDetails(items.scanned);
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.userLists.isNotEmpty) {
      this.barcode = '';

      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', // Color de la barra de escaneo
        'Cancelar', // Texto del botón de cancelar
        false, // Desactivar el flash
        ScanMode.DEFAULT, // Modo de escaneo predeterminado
      );

      print('Barcode: ' + barcode);

      if (barcode != '-1' && barcode.isNotEmpty) {
        this.barcode = barcode;
        final provider = Provider.of<ItemFormProvider>(context, listen: false);
        provider.barcode = this.barcode;
        _performAPICall();
      } else {
        Navigator.pushNamed(context, 'details');
      }
    } else {
      // No hay listas creadas, muestra un mensaje o realiza alguna otra acción
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No hay listas creadas'),
          content: Text(
              'Por favor, crea una lista antes de escanear códigos de barras.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        automaticallyImplyLeading: false,
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
        return CompareScreen();

      case 2:
        return SearchScreen();

      default:
        return const ListScreen();
    }
  }
}
