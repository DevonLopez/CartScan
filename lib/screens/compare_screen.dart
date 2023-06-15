import 'package:cart_scan/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:cart_scan/models/models.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class CompareScreen extends StatefulWidget {
  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  List<Item> _selectedItems = [];
  List<charts.Series<Item, String>> _chartData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.itemList = [];
      userProvider.getItems().then((_) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: userProvider.itemList.length,
            itemBuilder: (context, index) {
              Item item = userProvider.itemList[index];
              return CheckboxListTile(
                enabled: _selectedItems.length >= 2 &&
                        !_selectedItems.contains(userProvider.itemList[index])
                    ? false
                    : true,
                title: Text(item.name),
                value: _selectedItems.contains(item),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedItems.add(item);
                    } else {
                      _selectedItems.remove(item);
                    }
                    if (_selectedItems.length >= 2) {
                      _chartData.clear();

                      _generateChartData();
                      setState(() {});
                    } else {
                      _chartData.clear();
                      setState(() {});
                    }
                  });
                },
              );
            },
          ),
        ),
        if (_chartData.isNotEmpty)
          Expanded(
            child: charts.BarChart(
              _chartData,
              animate: true,
            ),
          ),
      ],
    );
  }

  void _generateChartData() {
    _chartData.clear();

    for (Item item in _selectedItems) {
      List<charts.Series<Item, String>> seriesList = [];

      if (item.offer) {
        double offerPrice = item.price * (1 - (item.discount / 100));
        seriesList.add(
          charts.Series<Item, String>(
            id: '${_getLimitedName(item.name)} (Oferta)',
            data: [item],
            domainFn: (Item item, _) => _getLimitedName(item.name),
            measureFn: (Item item, _) => offerPrice,
            colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green),
            labelAccessorFn: (Item item, _) =>
                '\$${offerPrice.toStringAsFixed(2)}',
          ),
        );
      }

      seriesList.add(
        charts.Series<Item, String>(
          id: '${_getLimitedName(item.name)} (Precio Original)',
          data: [item],
          domainFn: (Item item, _) => _getLimitedName(item.name),
          measureFn: (Item item, _) => item.price,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
          labelAccessorFn: (Item item, _) =>
              '\$${item.price.toStringAsFixed(2)}',
        ),
      );

      _chartData.addAll(seriesList);
    }
  }

  String _getLimitedName(String name) {
    List<String> words = name.split(' ');
    if (words.length > 2) {
      return words.sublist(0, 2).join(' ');
    } else {
      return name;
    }
  }
}
