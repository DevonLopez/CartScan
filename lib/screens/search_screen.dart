import 'package:cart_scan/models/models.dart';
import 'package:cart_scan/providers/providers.dart';
import 'package:cart_scan/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchQuery = '';
  List<Item> userItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.itemList = [];
      userProvider.getItems().then((_) {
        setState(() {
          userItems = userProvider.itemList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Item> filteredItems = userItems
        .where((item) =>
            item.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              Item item = filteredItems[index];
              return ListTile(
                title: Text(item.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(item: item),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
