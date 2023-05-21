import 'package:flutter/material.dart';

import '../screens/screens.dart';

var customRoutes = <String, WidgetBuilder>{
  'home': (context) => const HomeScreen(),
  'details': (context) => const DetailsScreen(),
  'scan': (context) => const ScanScreen(),
  'list': (context) => const ListScreen(),
  'search': (context) => const SearchScreen(),
  'compare': (context) => const CompareScreen(),
};
