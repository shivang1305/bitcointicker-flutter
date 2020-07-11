import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String currentValue = '?';
  String currencySymbol = '';

  Widget loader;

  List<DropdownMenuItem<String>> getDropdownMenu() {
    List<DropdownMenuItem<String>> items = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      items.add(newItem);
    }
    return items;
  }

  CoinData coinData = new CoinData();

  void calcValue() async {
    getLoader();
    var value = await coinData.getCoinData();
    setState(() {
      //to make loader invisible
      loader = null;
      currencySymbol = value['$selectedCurrency']['symbol'].toString();
      currentValue = value['$selectedCurrency']['last'].toString();
    });
  }

  @override
  void initState() {
    calcValue();
    super.initState();
  }

  void getLoader() {
    loader = SpinKitThreeBounce(
      color: Colors.blue,
      size: 25.0,
      duration: Duration(milliseconds: 1500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $currencySymbol$currentValue $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: loader,
          ),
          Container(
            height: 110.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: DropdownButton<String>(
              value: selectedCurrency,
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value;
                  calcValue();
                });
              },
              items: getDropdownMenu(),
            ),
          ),
        ],
      ),
    );
  }
}
