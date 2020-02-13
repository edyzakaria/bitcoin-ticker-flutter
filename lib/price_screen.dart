import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedValue = 'USD';
  Map<String, String> coinPriceTag = {};
  String bitCoinPriceTag = 'Getting price...';
  CoinData coinData = CoinData();

  @override
  void initState() {
    super.initState();
    updateCoin();
  }

  void updateCoin() async {
    for (String crypto in cryptoList) {
      coinPriceTag[crypto] = 'Getting prices...';
    }
    try {
      var data = await coinData.getCoinPrice(currency: selectedValue);
      setState(() {
        coinPriceTag = data;
        print(coinPriceTag);
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> androidDropDown () {

    List <DropdownMenuItem<String>> dropDownItems = [];
    for(String currency in currenciesList) {
      var newItem = DropdownMenuItem (
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton <String> (
        value: selectedValue,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            updateCoin();
          });
        });
  }

  CupertinoPicker iosPicker() {

    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  List<Widget> coinComponents() {
    List<Widget> padList = [];
    for (String crypto in cryptoList) {
//      bool priceIsNull = false;
//      if (coinPriceTag[crypto] == null) {priceIsNull = true;}
      var padItem = Padding(
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
              coinPriceTag[crypto],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      padList.add(padItem);
    }
    return padList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: coinComponents(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

