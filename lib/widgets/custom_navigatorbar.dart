import 'package:cart_scan/providers/ui_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final currentIndex = uiProvider.menuOpt;

    return BottomNavigationBar(
      onTap: (int i) => uiProvider.menuOpt = i,
      backgroundColor: const Color.fromARGB(255, 150, 226, 88),
      elevation: 0,
      currentIndex: currentIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Listas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare),
          label: 'Comparaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Productos',
        )
      ],
    );
  }
}
