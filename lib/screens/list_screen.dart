import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/user_provider.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser == null) {
      userProvider.getCurrentUserWithLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Center(
      child: userProvider.currentUser != null
          ? ListView.builder(
              itemCount: userProvider.currentUser!.lists!.length,
              itemBuilder: (context, index) {
                final shoppingList = userProvider.currentUser!.lists![index];

                return ListTile(
                  title: Text(shoppingList.name),
                  onTap: () {
                    // Abrir la lista y mostrar los elementos anidados
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListDetailScreen(
                          shoppingList: shoppingList,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : CircularProgressIndicator(),
    );
  }
}
