import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/screens/item_screen.dart';
import 'package:flutter/material.dart';

import '../screens/screens.dart';

var customRoutes = <String, WidgetBuilder>{
  'home': (context) => const HomeScreen(),
  'details': (context) => const DetailsScreen(),
  'scan': (context) => const ScanScreen(),
  'list': (context) => const ListScreen(),
  'search': (context) => SearchScreen(),
  'compare': (context) => CompareScreen(),
  'itemForm': (context) {
    final Item? itemBarcode =
        ModalRoute.of(context)?.settings.arguments as Item?;
    return ItemScreenForm(itemBarcode: itemBarcode);
  },
};
