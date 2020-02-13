import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitcoin_ticker/coin_data.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinURL = 'https://rest.coinapi.io/v1/exchangerate';
const coinAPIKey = '9AA66FE3-FFEB-4261-958C-9FD4BE907852';

class CoinData {
  CoinData ();

  String _coinName;
  String _currency;

  Future<dynamic> getCoinPrice ({String currency}) async {
    Map<String, String> cryptoPrices = {};
    this._currency = currency;
    for (String crypto in cryptoList) {
      this._coinName = crypto;
      String url = '$coinURL/$_coinName/$_currency?apikey=$coinAPIKey';
      http.Response response = await http.get(url).timeout(Duration(seconds: 20));
      if (response.statusCode == 200) {
        String data = response.body;
        double rate = jsonDecode(data)['rate'];
        cryptoPrices[crypto] = '1 ${this._coinName} = ${rate.toStringAsFixed(2)} ${this._currency}';
        print(cryptoPrices[crypto]);
      } else {
        print('Calling for $url get ${response.statusCode}');
//        throw('Error getting prices.');
        cryptoPrices[crypto] = '1 ${this._coinName} = 999 ${this._currency}';
      }
    }
  return cryptoPrices;
  }



}
