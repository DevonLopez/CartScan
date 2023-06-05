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

    // Generate series for each selected item
    for (Item item in _selectedItems) {
      List<charts.Series<Item, String>> seriesList = [];

      if (item.offer) {
        // Calculate offer price and add it as a separate series
        double offerPrice = item.price * (1 - (item.discount / 100));
        seriesList.add(
          charts.Series<Item, String>(
            id: '${item.name} (Oferta)',
            data: [item],
            domainFn: (Item item, _) => item.name,
            measureFn: (Item item, _) => offerPrice,
            colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green),
          ),
        );
      }

      // Add original price series
      seriesList.add(
        charts.Series<Item, String>(
          id: '${item.name} (Precio Original)',
          data: [item],
          domainFn: (Item item, _) => item.name,
          measureFn: (Item item, _) => item.price,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        ),
      );

      _chartData.addAll(seriesList);
    }
  }
}
